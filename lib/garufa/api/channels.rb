require 'cuba'
require 'cuba/render'

require 'yajl'
require 'yajl/json_gem'
require 'tilt/yajl'

require 'garufa/api/channel_filter'
require 'garufa/api/channel_stats'
require 'garufa/api/settings_setter'

module Garufa
  module API
    class Channels < Cuba

      plugin Cuba::Render
      plugin ChannelFilter
      plugin ChannelStats
      plugin SettingsSetter

      set :render, template_engine: 'yajl', views: File.expand_path("views", File.dirname(__FILE__))
    end

    Channels.define do

      on get, "channels/:channel/users" do |channel|
        res.write partial('users', stats: stats(channel).first)
      end

      on get, "channels/:channel" do |channel|
        res.write partial('channel', stats: stats(channel).first, filter: filter(req.params))
      end

      on get, "channels" do
        res.write partial('channels', stats: stats, filter: filter(req.params))
      end
    end
  end
end
