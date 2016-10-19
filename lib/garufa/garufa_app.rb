require 'goliath/api'
require 'goliath/connection'
require 'faye/websocket'

require 'garufa/config'
require 'garufa/websocket'
require 'garufa/api/server'
require 'garufa/version'

module Garufa

  # Default port for api and websocket servers
  DEFAULT_PORT = 8080

  Faye::WebSocket.load_adapter('goliath')

  class GarufaApp < Goliath::API

    # Extend goliath options with our own options.
    def options_parser(opts, options)

      options[:port] = DEFAULT_PORT

      opts.on('-V', '--version', 'Display version and exit') { puts "Garufa version #{Garufa::VERSION}"; exit }

      opts.separator ""
      opts.separator "Pusher options:"

      new_options = {
        app_id:  ['--app_id APP_ID',   'Pusher application ID (required)'],
        app_key: ['--app_key APP_KEY', 'Pusher application key (required)'],
        secret:  ['--secret SECRET',   'Pusher application secret (required)']
      }
      new_options.each do |k, v|
        opts.on(v.first, v.last) { |value| Garufa::Config[k] = value }
      end

      opts.on('--enable-client-events', 'Enable client events (default: false)') {
        Garufa::Config[:client_events_enabled] = true
      }
    end

    def response(env)
      if Faye::WebSocket.websocket?(env)
        WebSocket::Server.call(env)
      else
        API::Server.call(env)
      end
    end
  end
end
