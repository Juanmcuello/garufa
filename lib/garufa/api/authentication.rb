require 'signature'
require 'garufa/config'

module Authentication
  module InstanceMethods
    def authenticate(app_id)
      r = Signature::Request.new(request.request_method, request.path, request.params)
      r.authenticate { |key| Signature::Token.new(key, Garufa::Config[:secret]) }

      if app_id != Garufa::Config[:app_id]
        request.halt [400, {}, ["Token validated, but invalid for app #{app_id}"]]
      end

    rescue Signature::AuthenticationError
      request.halt [401, {}, ['401 Unauthorized']]
    end
  end
end

Roda.plugin Authentication
