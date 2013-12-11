require 'goliath'
require 'faye/websocket'
require 'faye/websocket/api/event_target'

require './ws_server'
require './api_server'

Faye::WebSocket.load_adapter('goliath')

class Garufa < Goliath::API
  def response(env)
    if Faye::WebSocket.websocket?(env)
      WsServer.call(env)
    else
      ApiServer.call(env)
    end
  end
end
