class Connection

  attr_reader :socket_id

  def initialize(socket)
    @socket = socket
  end

  def establish
    @socket_id = SecureRandom.uuid
    send_message Message.connection_established(@socket_id)
  end

  def handle_incomming_data(data)
    message = Message.new(data)
    case message.event
    when /pusher:/
      handle_pusher_message(message)
    when /client:/
      handle_client_message(message)
    end
  end

  def error(code, message)
    send_message Message.error(code, message)
  end

  def send_message(message)
    @socket.send message.to_json
  end

  def close
    @socket.close
  end

  private

  def handle_pusher_message(message)
    accepted_events = %w{ping pong subscribe unsubscribe}
    event_name = message.event.partition(':').last

    if accepted_events.include?(event_name)
      method("pusher_#{event_name}").call message.data
    end
  end

  def pusher_ping(data)
    send_message Message.pong
  end

  def pusher_pong(data)
    # There is nothing to do with a pong message
  end

  def pusher_subscribe(data)
    channel = data['channel']

    Subscriptions.add(channel, self)
    send_message Message.subscription_succeeded(channel)

  rescue Subscriptions::SubscriptionError => e
    error(nil, e.message)
  end

  def pusher_unsubscribe(data)
  end
end
