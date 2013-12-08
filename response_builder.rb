module ResponseBuilder
  extend self

  def connection_established(socket_id)
    build_response('connection_established', data: {socket_id: socket_id})
  end

  def subscription_succeeded(channel)
    build_response('subscription_succeeded', channel: channel, internal: true)
  end

  def pong
    build_response('pong')
  end

  def error(code, message)
    build_response('error', data: {code: code, message: message})
  end

  private

  def build_response(event, options = {})
    internal = options.delete(:internal)
    response = {event: "#{internal ? 'pusher_internal' : 'pusher'}:#{event}"}
    response.merge(options).to_json
  end
end
