module Garufa
  module API
    module Routes
      module Events
        Server.route('events') do |r|
          r.is 'events' do
            handler = EventHandler.new
            handler.handle(read_body)
            '{}'
          end

          # Legacy events
          r.is 'channels', String, 'events' do |channel|
            handler = EventHandler.new
            handler.handle_legacy(read_body, channel, request.GET)
            response.status = 202
            '{}'
          end
        end
      end
    end
  end
end
