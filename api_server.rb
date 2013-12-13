require 'cuba'
require './subscriptions'

ApiServer = Cuba.new do

  on "apps/:app_id" do |app_id|

    authenticate(req)

    # Events
    on post, "events" do
      channels = req["channels"] || [req["channel"]]
      Subscriptions.notify channels, req["name"], req["data"], socket_id: req["socket_id"]
    end

    # Channels
    on get, "channels" do
    end

    on get, "channels/:channel" do
    end

    # Users
    on get, "channels/:channel/users" do
    end
 end

end

def authenticate(req)
  req["name"] == "test" || halt([401, {}, ['401 Unauthorized']])
end
