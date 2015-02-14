module Garufa
  module API
    module Routes
      module Channels
        def self.included(mod)
          mod.define do
            # GET channels/presence-channel
            on terminalPrefix("presence-") do |channel|
              write 'presence', stats: channel_stats(channel), filter: filter(req.params)
            end

            # GET channels/presence-channel/users
            on "(presence-.*)/users" do |channel|
              write 'presence_users',  stats: channel_stats(channel)
            end

            # GET channels/non-presence-channel/users
            on ":channel/users" do |channel|
              res.status = 400
            end

            # GET channels/non-presence-channel
            on terminalPrefix("(?!presence-)") do |channel|
              write 'non_presence', stats: channel_stats(channel)
            end

            # GET channels
            on root do
              write 'channels', stats: channels_stats, filter: filter(req.params)
            end
          end
        end
      end
    end
  end
end
