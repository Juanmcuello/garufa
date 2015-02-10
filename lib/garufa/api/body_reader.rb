module Garufa
  module API
    module BodyReader
      def read_body
        body = req.body.read; req.body.rewind
        body
      end
    end
  end
end
