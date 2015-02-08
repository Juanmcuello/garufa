module Garufa
  module API
    module SettingsSetter
      module ClassMethods
        def set(key, value)
          if value.is_a? Hash
            settings[key].merge! value
          else
            settings[key] = value
          end
        end
      end
    end
  end
end
