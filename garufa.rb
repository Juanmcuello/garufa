require 'goliath/api'
require 'faye/websocket'

require './ws_server'
require './api_server'

Faye::WebSocket.load_adapter('goliath')

class Garufa < Goliath::API

  # Extend goliath options with our own options.
  def options_parser(opts, options)
    opts.separator ""
    opts.separator "Pusher options:"
    opts.on('--app_key APP_KEY', "Pusher application key (required)") { |value| options[:app_key] = value }
    opts.on('--secret SECRET', "Pusher application secret (required)") { |value| options[:secret] = value }
  end

  def response(env)

    # We will need the secret key for authentication.
    # Any way to do this better?
    env[:secret] = options[:secret]

    if Faye::WebSocket.websocket?(env)
      WsServer.call(env)
    else
      ApiServer.call(env)
    end
  end
end
