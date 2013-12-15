require 'goliath/api'
require 'faye/websocket'

require './config'
require './ws_server'
require './api_server'

module Garufa
  Faye::WebSocket.load_adapter('goliath')

  class GarufaApp < Goliath::API

    # Extend goliath options with our own options.
    def options_parser(opts, options)
      opts.separator ""
      opts.separator "Pusher options:"
      opts.on('--app_key APP_KEY', "Pusher application key (required)") { |value| Garufa::Config[:app_key] = value }
      opts.on('--secret SECRET', "Pusher application secret (required)") { |value| Garufa::Config[:secret] = value }
    end

    def response(env)
      if Faye::WebSocket.websocket?(env)
        WsServer.call(env)
      else
        ApiServer.call(env)
      end
    end
  end
end
