require 'signature'

class Cuba
  module Authentication
    def authenticate
      secret = 'sample_secret'
      request = Signature::Request.new(req.request_method, env['REQUEST_PATH'], req.params)
      request.authenticate { |key| Signature::Token.new(key, secret) }

    rescue Signature::AuthenticationError
      halt([401, {}, ['401 Unauthorized']])
    end
  end
end
