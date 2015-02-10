require 'cuba/render'

require 'yajl'
require 'yajl/json_gem'
require 'tilt/yajl'

require 'garufa/api/channel_filter'
require 'garufa/api/channel_stats'
require 'garufa/api/response_writer'
require 'garufa/api/terminal_matcher'
require 'garufa/api/settings_setter'

module Garufa
  module API

    class Channels < Cuba
      plugin Cuba::Render
      plugin ChannelStats
      plugin ChannelFilter
      plugin TerminalMatcher
      plugin ResponseWriter
      plugin SettingsSetter

      set :render, template_engine: 'yajl'
      set :render, views: File.expand_path("views", File.dirname(__FILE__))
    end

    Channels.define do

      # GET channels/presence-channel
      on terminalPrefix("presence-") do |channel|
        write 'presence', stats: channel_stats(channel), filter: filter(req.params)
      end

      # GET channels/presence-channel/users
      on "(presence-.*)/users" do |channel|
        write 'presence_users',  stats: channel_stats(channel)
      end

      # GET channels/non-presence-channel/users
      on ":channel/users" do |channel|
        res.status = 400
      end

      # GET channels/non-presence-channel
      on terminalPrefix("(?!presence-)") do |channel|
        write 'non_presence', stats: channel_stats(channel)
      end

      # GET channels
      on root do
        write 'channels', stats: channels_stats, filter: filter(req.params)
      end
    end
  end
end
