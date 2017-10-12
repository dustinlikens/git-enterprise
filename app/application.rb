require 'capybara'
# require 'poltergeist'
require 'capybara/poltergeist'
# require 'concurrent'
# require 'open-uri'
require 'phantomjs'
require 'rack'
require 'json'

# http://localhost:9292/?awd=A359807&pickup=12%2F02%2F2017&dropoff=12%2F10%2F2017
# http://localhost:9292/?discountCount=1&discount0=E999WES&pickupDate=20171020&returnDate=20171023

class Application
  def call(env)
    resp = Rack::Response.new
    req = Rack::Request.new(env)
    

    pagebody = ""
  output = {}
  c = req.params['discountCount'].to_i
  (0...c).each do |i|
    # agent = Mechanize.new
    # page = agent.get('https://legacy.enterprise.com/car_rental/home.do')
    # form = page.form('homePageForm')
    # form.field_with(name: 'searchCriteria').value = params[:location]
    # form.field_with(name: 'startDateInput').value = params[:pickupDay]
    # form.field_with(name: 'endDateInput').value = params[:returnDay]
    # form.field_with(name: 'startDateMonth').value = params[:pickupYearMonth]
    # form.field_with(name: 'endDateMonth').value = params[:returnYearMonth]
    # form.field_with(name: 'startDateTime').value = params[:pickupTime]
    # form.field_with(name: 'endDateTime').value = params[:returnTime]
    # form.field_with(name: 'optionalCode').value = params["discount#{i}".to_sym]
    # button = form.button_with(value: "Search")
    # page = agent.submit(form, button)
    # output = page.body



    Capybara.register_driver(:poltergeist) { |app| Capybara::Poltergeist::Driver.new(app, js_errors: false, debug: false, phantomjs_options: ['--load-images=false', '--disk-cache=false'] ) }
    Capybara.default_driver = :poltergeist

    page = Capybara.current_session     # the object we'll interact with
    page.driver.headers = { 'User-Agent' => 'Mozilla/5.0 (iPhone; U; CPU iPhone OS 5_0 like Mac OS X) AppleWebKit/534.46 (KHTML, like Gecko) Mobile/9A334 Safari/7534.48.3' }

    # 'https://assets.adobedtm.com'
    # 'https://www.enterprise.com/etc/designs/ecom/dist/fonts/'
    page.driver.browser.url_blacklist = ['https://assets.adobedtm.com', 'googleads.g.doubleclick.net', 'https://www.enterprise.com/etc/designs/ecom/dist/fonts/', 'https://cdnssl.clicktale.net', 'https://static.ads-twitter.com', 'https://developers.google.com', 'https://maps.googleapis.com', 'https://www.googleadservices.com']
    # page.driver.browser.url_whitelist = ['https://enterprise.com']
    
    url = 'https://google.com'
    page.visit url

    puts 'about to load enterprise'
    url = 'https://www.enterprise.com/en/car-rental/locations/us/ca/oceanside-32f6.html'

    page.visit url
    # puts page.driver.network_traffic.inspect

    # pickupCalendar = false
    # while pickupCalendar == false  do
    #   puts "waiting for pickupCalendar"
    #   pickupCalendar = true if page.body.include?('pickupCalendar')
    # end
    
    puts 'waiting for pickupCalendar'
    Capybara.using_wait_time(30) { page.body.include?('pickupCalendar') }
    # while !page.body.include?('pickupCalendar') do
    # end
    puts 'pickupCalendar available'
   #     element = page.find('input#coupon')

   #  element.native.send_key('E999WES')


   # sleep(0.5)


    page.find('label[for=pickupCalendar]').click
    sleep(0.1)

    # while !page.body.include?('Previous Month') do
    #   puts "waiting for Previous Month"
    #   sleep(0.2)
    # end
    # currentMonthYear = 'February 2017'
    # while page.body.include?('Previous Month') do
    #   page.find('button[aria-label="Previous Month"]').click
    #   sleep(0.2)
    #   puts "Previous month"
    # end

    # nextMonth = false
    # while !page.body.include?('Next Month') do
    #   puts "waiting for Next Month"
    # end
    Capybara.using_wait_time(30) { page.body.include?('Next Month') }
    puts "next month available"

    pickupDate = req.params['pickupDate']
    while !page.body.include?(pickupDate) do
    page.find('button[aria-label="Next Month"]').click
    puts "clicked next month"
    sleep(0.1)
    end
    sleep(0.1)

    
    # while !page.body.include?(pickupDate) do
    #   puts "waiting for pickupDate"
    # end
    # sleep(0.1)

    page.find("button[data-reactid*='#{pickupDate}']").click
    # sleep(0.5)

    Capybara.using_wait_time(30) { page.body.include?('dropoffCalendar') }
    # while !page.body.include?('dropoffCalendar') do
    # end

    page.find('label[for=dropoffCalendar]').click
    # sleep(0.5)


    returnDate = req.params['returnDate']
    Capybara.using_wait_time(30) { page.body.include?('returnDate') }
    # while !page.body.include?(returnDate) do
    # end
    sleep(0.1)
    page.find("button[data-reactid*='#{returnDate}']").click
    sleep(0.5)
    # end

   # evaluate_script("page.getElementById('coupon').value = 'E999WES'")
   # page.find_field('coupon').trigger('click')
   # sleep(0.5)
   # page.find_field('coupon').send_keys("E999WES")

   # page.find("span[aria-label='Clear Location']").click if page.body.include?('Clear Location')
   page.find('.coupon-field-wrapper').click if page.body.include?('coupon-chicklet removable')
    sleep(0.1)

    discountString = "discount#{i}"
    if !discountString.empty?
      element = page.find('input#coupon')
      element.native.send_key(req.params[discountString])
    end

   # sleep(0.5)
   # page.find('label[for=pickupTime]').click
   # # # page.find('label[for=pickupTime]').click.find(:xpath, '12:00 PM').select_option
   # # # page.find('id#dropoffTime').find(:xpath, '12:00 PM').select_option
   # # # page.select "12:00 PM", :from => page.find('label[for=pickupTime]')
   # # page.select "12:00 PM", from: "Pick-Up Time Selector"
   # # page.find_by_id('pickupTime').trigger.('click')
   # # page.find('id#pickupTime').click
   # # page.find('label[for=pickupTime]').click
   # # puts page.body
   # # page.find('option[value="12:00 PM"]').click
   # # page.find('label[for=pickupTime]').find("option[value='12:00 PM']").select_option
   # page.find('select[id="pickupTime"]').find("option[value='12:00 PM']").select_option
   # # puts page.find('label[for=pickupTime]').inspect

    Capybara.using_wait_time(30) { page.body.include?('pickupTime') }
    # while !page.body.include?('id="pickupTime"') do
    # end 

    # page.find('label[for=pickupTime]').click
    # page.find("option[value='1:00 PM']").click
    # element = page.find('pickupTime')

   # page.find_by_id('pickupTime').find("option[value='1:00 PM']").select_option

   # puts page.body

    # page.find('div[data-reactid*=".3.0.7"]').trigger('click')
    # page.find('booking-submit').click
    page.find_by_id('continueButton').trigger('click')

    sleep(15)
    Capybara.using_wait_time(30) { page.body.include?('Per Day') }
    # while !page.body.include?("Per Day") do
    #   sleep(0.1)
    # end

    noko = Nokogiri::HTML(page.body)
    output[req.params[discountString]] = []
    noko.css('.default-view').each do |div|
        # puts div.css('h2')[0].text
        # puts div.css('.rate-normal')[0].text
        # puts div.css('.rate-normal')[1].text

        matches = {}
        matches[:vehicleClass] = div.css('h2')[0].text unless div.css('h2')[0].nil? 
        matches[:dailyRate] = ""
        matches[:dailyRate] = div.css('.rate-normal')[0].text.gsub('$','').gsub(' ','') unless div.css('.rate-normal')[0].nil?
        matches[:totalPrice] = ""
        matches[:totalPrice] = div.css('.rate-normal')[1].text.gsub('$','').gsub(' ','') unless div.css('.rate-normal')[1].nil?
        output[req.params[discountString]] << matches
    end
  end
    output.to_json

    resp.write output
    resp.finish
  end
end