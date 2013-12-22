module Garufa
  module Subscriptions
    extend self

    def all
      subscriptions
    end

    def add(channel, connection)
      subscription = Subscription.new(channel, connection)

      if subscriptions[channel].include? subscription
        subscription.error(4001, "Already subscribed to channel: #{channel}")
      else
        subscriptions[channel] << subscription
      end
      subscription
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

    private

    def subscriptions
      @subscriptions ||= Hash.new []
    end
  end

  class Subscription
    attr_reader :channel, :connection, :error

    def initialize(channel, connection)
      @channel, @connection = channel, connection
    end

    def error(code, message)
      error = SubscriptionError.new(code, message)
    end

    def public?
      !(self.private? || self.presence?)
    end

    def private?
      @channel_prefix == 'private'
    end

    def presence?
      @channel_prefix == 'presence'
    end

    def valid?
      @error.nil?
    end

    private

    def channel_prefix
      @channel_prefix ||= @channel.partition('-').first
    end
  end

  class SubscriptionError < Struct.new(:code, :message)
  end
end
