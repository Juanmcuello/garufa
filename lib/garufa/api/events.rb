require 'garufa/api/event_handler'

module Garufa
  module API
    class Events < Cuba; end

    Events.plugin EventHandler

    Events.define do

      res.status = 202
      body = req.body.read

      # Events
      on "events" do
        handle_events(body)
        res.write "{}"
      end

      # Legacy events
      on "channels/:channel_id/events" do |channel_id|
        params = req.GET.merge(channels: [channel_id])
        handle_events(body, params)
        res.write "{}"
      end
    end
  end
end
