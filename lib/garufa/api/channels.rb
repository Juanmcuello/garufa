require 'cuba'
require 'cuba/render'

require 'yajl'
require 'yajl/json_gem'
require 'tilt/yajl'

require 'garufa/api/channel_filter'

module Garufa
  module API
    class Channels < Cuba; end

    Channels.plugin Cuba::Render
    Channels.plugin ChannelFilter

    Channels.settings[:render][:template_engine] = 'yajl'
    Channels.settings[:render][:views] = File.expand_path("views", File.dirname(__FILE__))

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
