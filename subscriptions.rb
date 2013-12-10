module Subscriptions
  extend self

  def all
    subscriptions
  end

  def add(channel, connection)
    subscriptions[channel] ||= []
    subscriptions[channel] << connection
  end

  def notify(channel, data)
    return unless (connections = subscriptions[channel]).any?

    connections.each do |connection|
      message = Message.new(event: 'event', data: data)
      connection.send_message(message)
    end
  end

  private

  def subscriptions
    @subscriptions ||= {}
  end
end

