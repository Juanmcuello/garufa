require 'cuba'

require 'garufa/api/authentication'
require 'garufa/api/event_handler'

module Garufa
  module API
    class Server < Cuba

      plugin Authentication

      define do
        on "apps/:app_id" do |app_id|

          authenticate

          # Events
          on post, "events" do
            # Process requests deferred in order to response immediately.
            EM.defer do
              event_handler = EventHandler.new(env.logger)
              event_handler.handle_event(req.body.read)
            end
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
