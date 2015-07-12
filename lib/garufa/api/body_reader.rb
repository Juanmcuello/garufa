module BodyReader
  module InstanceMethods
    def read_body
      body = request.body.read; request.body.rewind
      body
    end
  end
end

Roda.plugin BodyReader
