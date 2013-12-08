require 'json'

class Message

  attr_reader :event, :data, :socket_id, :owner, :name

  def initialize(raw_message)
    message    = JSON.parse(raw_message)
    @socket_id = message['socket_id']
    @event     = message['event']
    @data      = message['data']

    partition_event
  end

  def partition_event
    event_parts = @event.partition(/:|-/)
    @owner = event_parts.first
    @name = event_parts.last
  end

end
