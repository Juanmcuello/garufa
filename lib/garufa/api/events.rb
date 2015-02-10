require 'garufa/api/event_handler'
require 'garufa/api/status_setter'
require 'garufa/api/body_reader'

module Garufa
  module API

    class Events < Cuba
      plugin EventHandler
      plugin StatusSetter
      plugin BodyReader
    end

    Events.define do

      # Events
      on "events" do
        handle_events(read_body)
        status 202
        res.write "{}"
      end

      # Legacy events
      on "channels/:channel_id/events" do |channel_id|
        handle_events(read_body, req.GET.merge(channels: [channel_id]))
        status 202
        res.write "{}"
      end
    end
  end
end
