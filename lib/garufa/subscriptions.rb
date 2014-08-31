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
      channels.each do |channel|
        subscriptions[channel].each do |sub|
          # Skip notifying if the same socket_id is provided
          next if sub.socket_id == options[:socket_id]
          sub.notify Message.channel_event(channel, event, options[:data])
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
