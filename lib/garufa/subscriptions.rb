require 'set'
require 'garufa/message'

module Garufa
  module Subscriptions
    extend self

    def all
      subscriptions
    end

    def add(subscription)
      subs = subscriptions[subscription.channel] ||= Set.new
      subs.add subscription
    end

    def remove(subscription)
      channel = subscription.channel
      subscriptions[channel].delete subscription
      subscriptions.delete(channel) if channel_size(channel).zero?
    end

    def notify(channels, event, options = {})
      channels.each do |channel|
        notify_channel(channel, event, options)
      end
    end

    def notify_channel(channel, event, options)
      return if channel_size(channel).zero?

      subscriptions[channel].each do |sub|
        # Skip notifying if the same socket_id is provided
        next if sub.socket_id == options[:socket_id]

        # Skip notifying the same member (probably from different tabs)
        next if sub.presence_channel? and sub.channel_data == options[:data]

        sub.notify Message.channel_event(channel, event, options[:data])
      end
    end

    def include?(subscription)
      subs = subscriptions[subscription.channel]
      subs && subs.include?(subscription)
    end

    def channel_size(channel)
      (subscriptions[channel] || []).size
    end

    private

    def subscriptions
      @subscriptions ||= {}
    end
  end
end
