require 'garufa/subscriptions'

module Garufa
  module API
    module ChannelStats
      def channel_stats(channel)
        Subscriptions.channel_stats(channel)
      end

      def channels_stats
        Subscriptions.all.each_with_object({}) do |(channel, _), stats|
          stats[channel] = channel_stats(channel)
        end
      end
    end
  end
end

