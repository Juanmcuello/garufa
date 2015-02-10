module Garufa
  module API
    module StatusSetter
      def status(code)
        req.status = code
      end
    end
  end
end
