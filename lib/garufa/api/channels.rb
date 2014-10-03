module Garufa
  module API
    class Channels < Cuba; end

    # TODO: Implement channels requests
    Channels.define do

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
end
