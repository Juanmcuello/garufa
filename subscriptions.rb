module Subscriptions
  extend self

  def all
    subscriptions
  end

  def add(channel, connection)
    if subscriptions[channel].include? connection
      raise SubscriptionError.new(channel)
    end
    subscriptions[channel] << connection
  end

  def notify(channels, event, data, options = {})
    channels.each do |channel|
      next unless (connections = subscriptions[channel]).any?

      connections.each do |connection|
        next if connection.socket_id == options[:socket_id]
        connection.send_message(Message.new(event: event, data: data))
      end
    end
  end

  class SubscriptionError < StandardError
    def initialize(channel)
      super "Already subscribed to channel: #{channel}"
    end
  end

  private

  def subscriptions
    @subscriptions ||= Hash.new []
  end
end

