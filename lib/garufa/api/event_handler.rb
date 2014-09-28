require 'json'

require 'garufa/subscriptions'
require 'garufa/message'

module Garufa
  module API
    class EventHandler

      def initialize(logger)
        @logger = logger
      end

      def handle_event(body)
        message = Garufa::Message.new(JSON.parse(body))
        options = {
          data: message.data,
          socket_id: message.socket_id
        }
        Garufa::Subscriptions.notify message.channels, message.name, options

      rescue JSON::ParserError => e
        @logger.error e.inspect
      end
    end
  end
end
