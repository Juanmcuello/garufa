require 'garufa/subscriptions'

module Garufa
  module API
    module ChannelStats
      def stats(*channels)
        channels = Subscriptions.all.keys unless channels.any?

        channels.map do |channel|
          Subscriptions.channel_stats(channel)
        end
      end
    end
  end
end

