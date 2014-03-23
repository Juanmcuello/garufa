require 'set'
require 'garufa/message'

module Garufa
  module Subscriptions
    extend self

    def all
      subscriptions
    end

    def add(subscription)
      subscriptions[subscription.channel].add subscription
    end

    def remove(subscription)
      subscriptions[subscription.channel].delete subscription
    end

    def notify(channels, event, options = {})
      return unless channels.is_a?(Array) && channels.any?

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
      @subscriptions ||= Hash.new { |h, k| h[k] = Set.new }
    end
  end
end
