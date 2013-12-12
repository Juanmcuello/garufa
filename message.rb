require 'json'

class Message

  def initialize(attr)
    @attributes = attr.is_a?(String) ? JSON.parse(attr) : attr

    @attributes.each do |name, value|
      instance_variable_set("@#{name}", value)
      self.class.send(:attr_reader, name)
    end
  end

  def to_json
    @attributes.to_json
  end

  def self.connection_established(socket_id)
    new(event: 'pusher:connection_established', data: { socket_id: socket_id })
  end

  def self.subscription_succeeded(channel)
    new(event: 'pusher_internal:subscription_succeeded', channel: channel)
  end

  def self.pong
    new(event: 'pusher:pong')
  end

  def self.error(code, message)
    new(event: 'pusher:error', data: { code: code, message: message })
  end
end
