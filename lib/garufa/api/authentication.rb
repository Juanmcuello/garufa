require 'signature'
require 'garufa/config'

module Garufa
  module API
    module Authentication
      def authenticate(app_id)
        request = Signature::Request.new(req.request_method, req.path, req.params)
        request.authenticate { |key| Signature::Token.new(key, Garufa::Config[:secret]) }

        if app_id != Garufa::Config[:app_id]
          halt([400, {}, ["Token validated, but invalid for app #{app_id}"]])
        end
      rescue Signature::AuthenticationError
        halt([401, {}, ['401 Unauthorized']])
      end
    end
  end
end
