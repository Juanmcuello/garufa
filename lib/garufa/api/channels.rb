require 'cuba'
require 'cuba/render'

require 'yajl'
require 'yajl/json_gem'
require 'tilt/yajl'

require 'garufa/api/channel_filter'
require 'garufa/api/settings_setter'

module Garufa
  module API
    class Channels < Cuba
      plugin Cuba::Render
      plugin ChannelFilter
      plugin SettingsSetter

      set :render, template_engine: 'yajl', views: File.expand_path("views", File.dirname(__FILE__))
    end

    Channels.define do

      on get, "channels/:channel/users" do |channel|
        stats = Subscriptions.channel_stats(channel)
        res.write partial('users', stats: stats)
      end

      on get, "channels/:channel" do |channel|
        filter = channel_filter(req.params)
        stats = Subscriptions.channel_stats(channel)
        res.write partial('channel', stats: stats, filter: filter)
      end

      on get, "channels" do
        filter = channel_filter(req.params)
        stats = Subscriptions.all.each_with_object({}) do |(channel, sub), obj|
          obj[channel] = Subscriptions.channel_stats(channel)
        end

        res.write partial('channels', stats: stats, filter: filter)
      end
    end
  end
end
