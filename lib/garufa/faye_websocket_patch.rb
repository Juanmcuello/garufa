# This is included only to provide a fix when the 'env' was not set.
# This fix was already included in 'master' of faye-websocket-ruby,
# but not released as a gem yet.
#
# See https://github.com/faye/faye-websocket-ruby/issues/38
#
module Faye
  class WebSocket
    module Adapter
      def websocket?
        e = defined?(@env) ? @env : env
        e && WebSocket.websocket?(e)
      end
    end
  end
end
