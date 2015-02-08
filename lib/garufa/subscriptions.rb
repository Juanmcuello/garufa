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
      channel = subscription.channel
      subscriptions[channel].delete subscription
      subscriptions.delete(channel) if channel_size(channel) == 0
    end

    def notify(channels, event, options = {})
      channels.each do |channel|
        subscriptions[channel].each do |sub|

          # Skip notifying if the same socket_id is provided
          next if sub.socket_id == options[:socket_id]

          # Skip notifying the same member (probably from different tabs)
          next if sub.presence_channel? and sub.channel_data == options[:data]

          sub.notify Message.channel_event(channel, event, options[:data])
        end
      end
    end

    def include?(subscription)
      subscriptions[subscription.channel].include? subscription
    end

    def presence_data(channel)
      subs = subscriptions[channel]
      data = { count: subs.size, ids: [], hash: {} }

      subs.each do |sub|
        id, info = JSON.parse(sub.channel_data).values_at('user_id', 'user_info')
        data[:ids] << id
        data[:hash][id] = info
      end

      { presence: data }
    end

    private

    def subscriptions
      @subscriptions ||= Hash.new { |h, k| h[k] = Set.new }
    end
  end
end
