require 'garufa/connection'

module Garufa
  module WebSocket

    Server = proc do |env|
      socket = Faye::WebSocket.new(env)
      connection = Connection.new(socket, env.logger)

      socket.on :open do |event|
        connection.establish
      end

      socket.on :message do |event|
        connection.handle_incomming_data(event.data)
      end

      socket.on :close do |event|
        socket = nil
      end

      # Return async Rack response
      socket.rack_response
    end
  end
end
