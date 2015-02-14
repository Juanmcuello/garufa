require 'cuba/render'

require 'yajl'
require 'yajl/json_gem'
require 'tilt/yajl'

require 'garufa/api/channel_filter'
require 'garufa/api/channel_stats'
require 'garufa/api/response_writer'
require 'garufa/api/terminal_matcher'
require 'garufa/api/settings_setter'
require 'garufa/api/routes/channels'

module Garufa
  module API

    class Channels < Cuba
      plugin Cuba::Render
      plugin ChannelFilter
      plugin ChannelStats
      plugin ResponseWriter
      plugin TerminalMatcher
      plugin SettingsSetter

      set :render, template_engine: 'yajl'
      set :render, views: File.expand_path("views", File.dirname(__FILE__))

      include ::Routes::Channels
    end
  end
end
