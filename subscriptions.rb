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
    subscriptions[channel].each do |connection|
      connection.send_to_client data.to_json
    end
  end

  private

  def subscriptions
    @subscriptions ||= {}
  end
end

