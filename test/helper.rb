$:.unshift(File.expand_path("../lib", File.dirname(__FILE__)))

require "garufa"
require 'minitest/autorun'
require 'minitest/mock'

Garufa::Config[:app_key] = '123123-123123'
Garufa::Config[:secret] = '456456-456456'

def sign(socket_id, custom_string = nil)
  string_to_sign = [socket_id, custom_string].join(':')
  digest = OpenSSL::Digest::SHA256.new
  return OpenSSL::HMAC.hexdigest(digest, Garufa::Config[:secret], string_to_sign)
end
