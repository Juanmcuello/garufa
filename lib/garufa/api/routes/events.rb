module Garufa
  module API
    module Routes
      module Events
        def self.included(mod)

          mod.define do
            # Events
            on "events" do
              handle_events(read_body)
              res.status = 202
              res.write '{}'
            end

            # Legacy events
            on "channels/:channel/events" do |channel|
              handle_events(read_body, channel, req.GET)
              res.status = 202
              res.write '{}'
            end
          end
        end
      end
    end
  end
end
