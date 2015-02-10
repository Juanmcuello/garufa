module Garufa
  module API
    module TerminalMatcher
      def terminalPrefix(prefix)
        /(#{prefix}((?!\/).)*)\z/
      end
    end
  end
end
