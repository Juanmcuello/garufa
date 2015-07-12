require 'minitest'
require 'minitest/autorun'
require 'minitest/mock'
require 'rack/test'
require 'digest/md5'

require_relative "../lib/garufa"

Garufa::Config[:app_id]  = '123123123'
Garufa::Config[:app_key] = '123123-123123'
Garufa::Config[:secret]  = '456456-456456'

module Garufa
  module Test

    module ConnectionHelpers
      def sign_string(socket_id, custom_string = nil)
        string = [socket_id, custom_string].join(':')
        secret = Garufa::Config[:secret]
        digest = OpenSSL::Digest::SHA256.new

        OpenSSL::HMAC.hexdigest(digest, secret, string)
      end
    end

    module RackHelpers
      def sign_params(verb, uri, params = {})
        token   = Signature::Token.new(Garufa::Config[:app_key], Garufa::Config[:secret])
        request = Signature::Request.new(verb.to_s.upcase, uri.path, params)

        params.merge(request.sign(token))
      end

      def signed_post(uri, params = {})
        if params.any?
          body_md5 = Digest::MD5.hexdigest(params.to_json)
        end

        query_params = sign_params(:post, uri, params.merge(body_md5: body_md5))
        uri.query = URI.encode_www_form(query_params)

        post uri.to_s, params
      end

      def signed_get(uri)
        get uri.to_s, sign_params(:get, uri)
      end
    end
  end
end
