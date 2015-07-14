module Garufa
  module API
    Server.route('events') do |r|
      r.is 'events' do
        handler = EventHandler.new
        handler.handle(read_body)
        response.status = 202
        '{}'
      end

      # Legacy events
      r.is 'channels/:channel/events' do |channel|
        handler = EventHandler.new
        handler.handle_legacy(read_body, channel, request.GET)
        response.status = 202
        '{}'
      end
    end
  end
end
