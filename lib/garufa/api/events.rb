require 'garufa/api/event_handler'
require 'garufa/api/body_reader'
require 'garufa/api/routes/events'

module Garufa
  module API

    class Events < Cuba
      plugin EventHandler
      plugin BodyReader

      include Routes::Events
    end
  end
end
