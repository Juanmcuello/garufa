module Garufa
  module API
    module ResponseWriter
      def write(template, locals)
        res.write partial(template, locals)
      end
    end
  end
end
