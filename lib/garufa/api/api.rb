require 'cuba'

require 'garufa/cuba/authentication'
require 'garufa/api/handler'

module Garufa
  module Api
    Cuba.plugin Cuba::Authentication

    Server = Cuba.new do
      handler = Handler.new(env.logger)

      on "apps/:app_id" do |app_id|

        authenticate

        # Events
        on post, "events" do
          # Process requests deferred in order to response immediately.
          EM.defer proc { handler.handle_events(req.body.read) }
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
