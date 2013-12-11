require './connection'
require './message'
require './subscriptions'

WsServer = lambda do |env|
  socket = Faye::WebSocket.new(env)
  connection = Connection.new(socket)

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

