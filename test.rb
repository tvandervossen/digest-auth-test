#!/usr/bin/env ruby

require 'uri'
require 'net/http'
require 'net/http/digest_auth'

uri = URI('http://stuff.vandervossen.net/basic_auth_test/index.txt')
request = Net::HTTP::Get.new(uri)
request.basic_auth 'thijs', 'secret'
response = Net::HTTP.start(uri.hostname, uri.port) {|http|
  http.request(request)
}
puts response.body

digest_auth = Net::HTTP::DigestAuth.new
uri = URI.parse('http://stuff.vandervossen.net/digest_auth_test/index.txt')
uri.user = 'thijs'
uri.password = 'secret'
client = Net::HTTP.new(uri.host, uri.port)
request = Net::HTTP::Get.new(uri.request_uri)
response = client.request(request)
auth = digest_auth.auth_header(uri, response['www-authenticate'], 'GET')
request = Net::HTTP::Get.new(uri.request_uri)
request.add_field 'Authorization', auth
response = client.request(request)
puts response.body