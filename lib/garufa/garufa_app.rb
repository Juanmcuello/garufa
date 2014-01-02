require 'goliath/api'
require 'goliath/connection'
require 'faye/websocket'
require 'garufa/config'
require 'garufa/websocket/websocket'
require 'garufa/api/api'

# Remove this require after next release of faye-websocket-ruby.
# See https://github.com/faye/faye-websocket-ruby/issues/38
require 'garufa/faye_websocket_patch'

module Garufa
  Faye::WebSocket.load_adapter('goliath')

  class GarufaApp < Goliath::API

    # Extend goliath options with our own options.
    def options_parser(opts, options)
      opts.separator ""
      opts.separator "Pusher options:"

      new_options = {
        app_key: ['--app_key APP_KEY', 'Pusher application key (required)'],
        secret:  ['--secret SECRET',   'Pusher application secret (required)']
      }
      new_options.each do |k, v|
        opts.on(v.first, v.last) { |value| Garufa::Config[k] = value }
      end
    end

    def response(env)
      if Faye::WebSocket.websocket?(env)
        WebSocket::Server.call(env)
      else
        Api::Server.call(env)
      end
    end
  end
end
