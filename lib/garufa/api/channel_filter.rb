module Garufa
  module API
    module ChannelFilter
      def filter(params)
        {
          info: params['info'].to_s.split(/\s*,\s*/),
          prefix: params['filter_by_prefix']
        }
      end
    end
  end
end
