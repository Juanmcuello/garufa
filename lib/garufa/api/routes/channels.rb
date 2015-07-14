module Garufa
  module API
    module Routes
      module Channels
        Server.route('channels') do |r|
          r.on 'channels' do

            stats = Stats.new(Subscriptions.all)

            # GET channels
            r.is do
              render 'channels', locals: { stats: stats.all_channels, filter: filter(request.params) }
            end

            # GET channels/presence-channel
            r.is "presence-:channel" do |channel|
              render 'presence', locals: { stats: stats.single_channel(channel), filter: filter(request.params) }
            end

            # GET channels/presence-channel/users
            r.is /(presence-.+)\/users/ do |channel|
              render 'presence_users', locals: { stats: stats.single_channel(channel) }
            end

            # GET channels/non-presence-channel
            r.is ":channel" do |channel|
              render 'non_presence', locals: { stats: stats.single_channel(channel) }
            end

            # GET channels/non-presence-channel/users
            r.is ":channel/users" do |channel|
              response.status = 400
            end
          end
        end
      end
    end
  end
end
