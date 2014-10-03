require 'cuba'
require 'garufa/api/authentication'
require 'garufa/api/events'
require 'garufa/api/channels'

module Garufa
  module API
    class Server < Cuba; end

    Server.plugin Authentication

    Server.define do
      on "apps/:app_id" do |app_id|

        authenticate

        on post do
          run Events
        end

        on get do
          run Channels
        end
      end
    end
  end
end
