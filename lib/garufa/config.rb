module Garufa
  module Config
    extend self

    def [](key)
      settings[key]
    end

    def []=(key, value)
      settings[key] = value
    end

    def settings
      @settings ||= {}
    end
  end
end
