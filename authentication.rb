require 'signature'

class Cuba
  module Authentication
    def authenticate
      request = Signature::Request.new(req.request_method, env['REQUEST_PATH'], req.params)
      request.authenticate { |key| Signature::Token.new(key, Garufa::Config[:secret]) }

    rescue Signature::AuthenticationError
      halt([401, {}, ['401 Unauthorized']])
    end
  end
end
