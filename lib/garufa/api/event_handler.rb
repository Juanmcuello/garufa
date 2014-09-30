require 'json'

require 'garufa/subscriptions'
require 'garufa/message'

module Garufa
  module API
    module EventHandler
      def handle_events(body, params = {})
        body_params = JSON.parse(body)

        # Some old api clients send channel and event in the url, while only data is
        # in the body. New clients send everything in the body. We have to check where
        # data is coming to build the final params.
        params.merge!(body_params['data'] ? body_params : { data: body_params })

        message = Garufa::Message.new(params)
        options = { data: message.data, socket_id: message.socket_id }

        # Process event deferred in order to response immediately.
        EM.defer { Garufa::Subscriptions.notify message.channels, message.name, options }

      rescue JSON::ParserError => e
        env.logger.error e.inspect
      end
    end
  end
end
