require 'garufa/api/event_handler'
require 'garufa/api/body_reader'

module Garufa
  module API

    class Events < Cuba
      plugin EventHandler
      plugin BodyReader
    end

    Events.define do

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
