class Cuba
  module Authentication
    def authenticate
      req["name"] == "test" || halt([401, {}, ['401 Unauthorized']])
    end
  end
end
