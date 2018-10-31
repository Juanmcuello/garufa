module Garufa
  module API
    class Stats

      attr_reader :subscriptions

      def initialize(subscriptions)
        @subscriptions = subscriptions
      end

      def single_channel(channel)
        { size: channel_size(channel), presence: presence(channel) }
      end

      def all_channels
        subscriptions.each_with_object({}) do |(channel, _), stats|
          stats[channel] = single_channel(channel)
        end
      end

      def channel_size(channel)
        (subscriptions[channel] || []).size
      end

      private

      def presence(channel)
        return unless channel.start_with?('presence-')

        data = { ids: [], hash: {} }

        (subscriptions[channel] || []).each do |sub|

          channel_data = JSON.parse(sub.channel_data)
          id, info = channel_data.values_at('user_id', 'user_info')

          next if data[:ids].include?(id)

          data[:ids] << id
          data[:hash][id] = info
        end

        data.merge(count: data[:ids].count)
      end
    end
  end
end
