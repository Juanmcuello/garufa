module Goliath
  class Connection < EM::Connection
    alias :goliath_post_init :post_init

    # Ensure GOLIATH_ENV is set on new connections
    #
    # See https://github.com/postrank-labs/goliath/pull/279
    #
    def post_init
      Thread.current[GOLIATH_ENV] = nil
      goliath_post_init
    end
  end
end
