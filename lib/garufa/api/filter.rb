module Filter
  module InstanceMethods
    def filter
      {
        info: request.params['info'].to_s.split(/\s*,\s*/),
        prefix: request.params['filter_by_prefix']
      }
    end
  end
end

Roda.plugin Filter
