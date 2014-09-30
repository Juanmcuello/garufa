require 'cuba'

require 'garufa/api/authentication'
require 'garufa/api/event_handler'

module Garufa
  module API
    class Server < Cuba

      plugin Authentication
      plugin EventHandler

      define do
        on "apps/:app_id" do |app_id|

          authenticate

          # Events
          on post, "events" do
            handle_events(req.body.read)
            res.status = 202
            res.write "{}"
          end

          # Legacy events
          on post, "channels/:channel_id/events" do |channel_id|
            handle_events(req.body.read, req.GET.merge(channels: [channel_id]))
            res.status = 202
            res.write "{}"
          end

          # Channels
          on get, "channels" do
          end

          on get, "channels/:channel" do
          end

          # Users
          on get, "channels/:channel/users" do
          end
        end
      end
    end
  end
end
