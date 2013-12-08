require 'goliath'
require 'faye/websocket'
require 'faye/websocket/api/event_target'
require './subscriptions'
require './connection'
require './message'

Faye::WebSocket.load_adapter('goliath')

class Server < Goliath::API

  def response(env)

    if Faye::WebSocket.websocket?(env)
      socket = Faye::WebSocket.new(env)
      connection = Connection.new(socket)

      socket.on :open do |event|
        connection.establish
      end

      socket.on :message do |event|
        message = Message.new(event.data)
        connection.respond_to_message(message)
      end

      socket.on :close do |event|
        socket = nil
      end

      # Return async Rack response
      socket.rack_response

    else
      # Normal HTTP request
      Subscriptions.notify 'channel-142', {test: 'data'}

      [200, {'Content-Type' => 'text/plain'}, ['Hello normal http!']]
    end
  end

end
