module Garufa
  module Subscriptions
    extend self

    def all
      subscriptions
    end

    def add(subscription)
      subscriptions[subscription.channel] << subscription
    end

    def notify(channels, event, options = {})
      channels.each do |channel|
        connections = subscriptions[channel].map { |s| s.connection }
        next unless connections.any?

        connections.each do |connection|
          next if connection.socket_id == options[:socket_id]

          message = Message.channel_event(channel, event, options[:data])
          connection.send_message(message)
        end
      end
    end

    def include?(subscription)
      subscriptions[subscription.channel].include? subscription
    end

    private

    def subscriptions
      @subscriptions ||= Hash.new []
    end
  end

  class Subscription
    attr_reader :data, :connection, :error

    def initialize(data, connection)
      @data, @connection = data, connection
    end

    def subscribe
      case true
      when invalid_channel?
        set_error(nil, 'Invalid channnel or not present')
      when invalid_signature?
        set_error(nil, 'Invalid signature')
      when already_subscribed?
        set_error(nil, "Already subscribed to channel: #{channel}")
      else
        Subscriptions.add self
      end
    end

    def public_channel?
      !(private_channel? || presence_channel?)
    end

    def private_channel?
      channel_prefix == 'private'
    end

    def presence_channel?
      channel_prefix == 'presence'
    end

    def set_error(code, message)
      @error = SubscriptionError.new(code, message)
    end

    def success?
      @error.nil?
    end

    def channel
      @data['channel']
    end

    def channel_prefix
      channel[/^private-|presence-/].to_s[0...-1]
    end

    private

    def invalid_channel?
      !channel.is_a?(String) || channel.empty?
    end

    def invalid_signature?
      return false if public_channel?

      string_to_sign = [@connection.socket_id, channel].compact.join(':')
      token(string_to_sign) != @data["auth"].split(':').last
    end

    def token(string_to_sign)
      digest = OpenSSL::Digest::SHA256.new
      OpenSSL::HMAC.hexdigest(digest, Config[:secret], string_to_sign)
    end

    def already_subscribed?
      Subscriptions.include? self
    end
  end

  class SubscriptionError < Struct.new(:code, :message)
  end
end
