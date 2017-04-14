require 'roda'
require 'yajl'
require 'yajl/json_gem'
require 'tilt/yajl'

require_relative '../subscriptions'
require_relative 'stats'
require_relative 'filter'
require_relative 'authentication'
require_relative 'body_reader'
require_relative 'event_handler'

module Garufa
  module API
    class Server < Roda

      plugin :multi_route
      plugin :render, { engine: 'yajl', views: File.expand_path("views", File.dirname(__FILE__)) }

      require_relative 'routes/channels'
      require_relative 'routes/events'

      route do |r|
        r.on 'healthz', method: [:head, :get] do
          response.status = 204
        end

        r.on 'apps/:app_id' do |app_id|

          authenticate(app_id)

          r.get do
            r.route 'channels'
          end

          r.post do
            r.route 'events'
          end
        end
      end
    end
  end
end
