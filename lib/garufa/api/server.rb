require 'roda'
require 'yajl'
require 'yajl/json_gem'
require 'tilt/yajl'

require_relative '../subscriptions'
require_relative 'stats'
require_relative 'filter'
require_relative 'authentication'
require_relative 'body_reader'
require_relative 'event_handler'

module Garufa
  module API
    class Server < Roda

      plugin :render, { engine: 'yajl', views: File.expand_path("views", File.dirname(__FILE__)) }

      route do |r|
        r.on 'apps/:app_id' do |app_id|

          authenticate(app_id)

          r.post do

            # Events
            r.is 'events' do
              handler = EventHandler.new
              handler.handle(read_body)
              response.status = 202
              '{}'
            end

            # Legacy events
            r.is 'channels/:channel/events' do |channel|
              handler = EventHandler.new
              handler.handle_legacy(read_body, channel, request.GET)
              response.status = 202
              '{}'
            end
          end

          r.get do
            r.on 'channels' do

              stats = Stats.new(Subscriptions.all)

              # GET channels
              r.is do
                render 'channels', locals: { stats: stats.all_channels, filter: filter(request.params) }
              end

              # GET channels/presence-channel
              r.is "presence-:channel" do |channel|
                render 'presence', locals: { stats: stats.single_channel(channel), filter: filter(request.params) }
              end

              # GET channels/presence-channel/users
              r.is /(presence-.+)\/users/ do |channel|
                render 'presence_users', locals: { stats: stats.single_channel(channel) }
              end

              # GET channels/non-presence-channel
              r.is ":channel" do |channel|
                render 'non_presence', locals: { stats: stats.single_channel(channel) }
              end

              # GET channels/non-presence-channel/users
              r.is ":channel/users" do |channel|
                response.status = 400
              end

            end
          end
        end
      end
    end
  end
end
