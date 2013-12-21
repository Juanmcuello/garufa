require 'goliath/api'
require 'goliath/connection'
require 'faye/websocket'
require 'garufa/config'
require 'garufa/ws_server'
require 'garufa/api_server'

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
        WsServer.call(env)
      else
        ApiServer.call(env)
      end
    end
  end
end
