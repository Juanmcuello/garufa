require 'cuba'

require 'garufa/api/authentication'
require 'garufa/api/events'
require 'garufa/api/channels'

module Garufa
  module API

    class Server < Cuba
      plugin Authentication
    end

    Server.define do
      on "apps/:app_id" do |app_id|

        authenticate(app_id)

        on post do
          run Events
        end

        on get, 'channels' do
          run Channels
        end
      end
    end
  end
end
