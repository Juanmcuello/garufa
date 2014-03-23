require 'json'

require 'garufa/subscriptions'
require 'garufa/message'

module Garufa
  module Api
    module Handler
      def self.handle_events(body)
        message = Garufa::Message.new(JSON.parse(body))
        options = { data: message.data, socket_id: message.socket_id }
        Garufa::Subscriptions.notify message.channels, message.name, options
      rescue JSON::ParserError
      end
    end
  end
end
