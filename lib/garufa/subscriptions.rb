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
      subscriptions.delete(channel) if channel_size(channel) == 0
    end

    def notify(channels, event, options = {})
      channels.each do |channel|
        notify_channel(channel, event, options)
      end
    end

    def notify_channel(channel, event, options)
      return if channel_size(channel) == 0

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
      subs = subscriptions[channel]
      subs ? subs.size : 0
    end

    def channel_data(channel)
      response = { ids: [], hash: {} }

      (subscriptions[channel] || []).each do |sub|
        data = JSON.parse(sub.channel_data)
        id, info = data.values_at('user_id', 'user_info')

        next if response[:ids].include? id

        response[:ids] << id
        response[:hash][id] = info
      end
      response[:count] = response[:ids].count
      response
    end

    def channel_stats(channel)
      {
        name: channel,
        size: channel_size(channel),
        presence: channel_data(channel)
      }
    end

    private

    def subscriptions
      @subscriptions ||= {}
    end
  end
end
