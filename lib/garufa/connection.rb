require 'uri'

module Garufa
  class Connection

    attr_reader :socket_id

    def initialize(socket, logger)
      @socket = socket
      @logger = logger
      @socket_id = SecureRandom.uuid
      @subscriptions = {}
    end

    def establish
      if valid_app_key?
        send_message Message.connection_established(@socket_id)
      else
        error(4001, "Could not find app by key #{app_key}")
        close
      end
    end

    def handle_incomming_data(data)
      @logger.debug "Incomming message. #{@socket_id}: #{data}"

      message = Message.new(JSON.parse(data))
      event, data = message.event, message.data

      case event
      when /^pusher:/
        handle_pusher_event(event, data)
      when /^client-/
        handle_client_event(event, data)
      end
    end

    def error(code, message)
      send_message Message.error(code, message)
    end

    def send_message(message)
      @logger.debug "Outgoing message. #{@socket_id}: #{message.to_json}"

      @socket.send message.to_json
    end

    def close
      @socket.close
    end

    def cleanup
      @subscriptions.values.each(&:unsubscribe)
      @subscriptions.clear
    end

    private

    def handle_pusher_event(event, data)
      accepted_events = %w{ping pong subscribe unsubscribe}
      event_name = event.partition(':').last

      if accepted_events.include?(event_name)
        method("pusher_#{event_name}").call data
      end
    end

    def handle_client_event(event, data)
      # NOTE: not supported yet
      error(nil, 'Client events are not supported yet')
    end

    def pusher_ping(data)
      send_message Message.pong
    end

    def pusher_pong(data)
      # There is nothing to do with a pong message
    end

    def pusher_subscribe(data)
      subscription = Subscription.new(data, self)
      subscription.subscribe

      if subscription.success?
        @subscriptions[subscription.channel] = subscription
        send_subscription_succeeded(subscription) unless subscription.public_channel?
      else
        error(subscription.error.code, subscription.error.message)
      end
    end

    def pusher_unsubscribe(data)
      subscription = @subscriptions.delete data["channel"]
      subscription.unsubscribe if subscription
    end

    def valid_app_key?
      app_key && (app_key == Config[:app_key])
    end

    def app_key
      @app_key ||= URI.parse(@socket.url).path.split('/').last
    end

    def send_subscription_succeeded(subscription)
      send_message Message.subscription_succeeded(subscription.channel)
    end
  end
end
