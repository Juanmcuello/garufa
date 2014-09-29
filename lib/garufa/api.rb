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
            handle_event(req.body.read)
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
