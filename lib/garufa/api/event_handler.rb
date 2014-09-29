require 'json'

require 'garufa/subscriptions'
require 'garufa/message'

module Garufa
  module API
    module EventHandler
      def handle_event(body)
        message = Garufa::Message.new(JSON.parse(body))
        options = { data: message.data, socket_id: message.socket_id }

        # Process event deferred in order to response immediately.
        EM.defer { Garufa::Subscriptions.notify message.channels, message.name, options }

      rescue JSON::ParserError => e
        env.logger.error e.inspect
      end
    end
  end
end
