require 'signature'
require 'garufa/config'

module Garufa
  module API
    module Authentication
      def authenticate
        request = Signature::Request.new(req.request_method, req.path, req.params)
        request.authenticate { |key| Signature::Token.new(key, Garufa::Config[:secret]) }

      rescue Signature::AuthenticationError
        halt([401, {}, ['401 Unauthorized']])
      end
    end
  end
end
