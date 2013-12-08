require './response_builder'

class Connection

  attr_reader :socket_id

  def initialize(socket)
    @socket = socket
  end

  def establish
    @socket_id = SecureRandom.uuid
    send_to_client ResponseBuilder.connection_established(@socket_id)
  end

  def respond_to_message(message)
    case message.owner
      when 'pusher'
        handle_pusher_message(message)
      when 'client'
        handle_client_message(message)
    end
  end

  def send_error(code, message)
    send_to_client ResponseBuilder.error(code, message)
  end

  def send_to_client(message)
    @socket.send message
  end

  private

  def handle_pusher_message(message)
    alloweds = %w{ping pong subscribe unsubscribe}

    if alloweds.include?(message.name)
      method("pusher_#{message.name}").call message.data
    end
  end

  def pusher_ping(data)
    send_to_client ResponseBuilder.pong
  end

  def pusher_pong
    # There is nothing to do with a pong message
  end

  def pusher_subscribe(data)
    channel = data['channel']
    Subscriptions.add(channel, self)
    send_to_client ResponseBuilder.subscription_succeeded(channel)
  end

  def pusher_unsubscribe(data)
  end
end
