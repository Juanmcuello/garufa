require 'json'

require 'garufa/subscriptions'
require 'garufa/message'

module Garufa
  module API
    class EventHandler

      def handle(body)
        notify JSON.parse(body)
      end

      def handle_legacy(body, channel, params)
        notify params.merge(channels: [channel], data: JSON.parse(body))
      end

      private

      def notify(params)
        message = Garufa::Message.new(params)
        options = { data: message.data, socket_id: message.socket_id }

        # Notify event deferred in order to response immediately.
        EM.defer { Garufa::Subscriptions.notify message.channels, message.name, options }
      end
    end
  end
end
