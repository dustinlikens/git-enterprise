# require 'net/http'
# postData = Net::HTTP.post_form(URI.parse('https://www.avis.com/webapi/v1/reservation/vehicles'), {"rqHeader":{"brand":"","locale":"en_US"},"nonUSShop":false,"pickInfo":"OCN","pickCountry":"US","pickDate":"10/10/2017","pickTime":"12:00 PM","dropInfo":"OCN","dropDate":"10/17/2017","dropTime":"12:00 PM","couponNumber":"","couponInstances":"","couponRateCode":"","discountNumber":"A359807","rateType":"LEISURE","residency":"US","age":25,"wizardNumber":"","lastName":"","userSelectedCurrency":"USD","selDiscountNum":"","promotionalCoupon":"","preferredCarClass":""})
# puts postData.body


require 'httpclient'
clnt = HTTPClient.new
res = clnt.post('https://www.avis.com/webapi/v1/reservation/vehicles', {"rqHeader":{"brand":"","locale":"en_US"},"nonUSShop":false,"pickInfo":"OCN","pickCountry":"US","pickDate":"10/10/2017","pickTime":"12:00 PM","dropInfo":"OCN","dropDate":"10/17/2017","dropTime":"12:00 PM","couponNumber":"","couponInstances":"","couponRateCode":"","discountNumber":"A359807","rateType":"LEISURE","residency":"US","age":25,"wizardNumber":"","lastName":"","userSelectedCurrency":"USD","selDiscountNum":"","promotionalCoupon":"","preferredCarClass":""})
puts res.body