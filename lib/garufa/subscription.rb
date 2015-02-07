require 'garufa/config'
require 'garufa/subscriptions'

module Garufa
  class Subscription

    attr_reader :error

    def initialize(data, connection)
      @data, @connection = data, connection
    end

    def subscribe
      case true
      when !valid_channel?
        set_error(nil, 'Invalid channel')
      when !public_channel? && !valid_signature?
        set_error(nil, 'Invalid signature')
      when !public_channel? && !valid_app_key?
        set_error(nil, 'Invalid key')
      when already_subscribed?
        set_error(nil, "Already subscribed to channel: #{channel}")
      else
        Subscriptions.add self
      end
    end

    def unsubscribe
      Subscriptions.remove self
    end

    def public_channel?
      !(private_channel? || presence_channel?)
    end

    def private_channel?
      channel_prefix == 'private'
    end

    def presence_channel?
      channel_prefix == 'presence'
    end

    def set_error(code, message)
      @error = SubscriptionError.new(code, message)
    end

    def success?
      @error.nil?
    end

    def channel
      @data['channel']
    end

    def channel_data
      @data['channel_data']
    end

    def channel_prefix
      channel[/^private-|presence-/].to_s[0...-1]
    end

    def notify(message)
      @connection.send_message message
    end

    def socket_id
      @connection.socket_id
    end

    private

    def valid_channel?
      channel.is_a?(String) && !channel.empty?
    end

    def valid_app_key?
      app_key && app_key == Config[:app_key]
    end

    def valid_signature?
      string_to_sign = [@connection.socket_id, channel, channel_data].compact.join(':')
      token(string_to_sign) == signature
    end

    def token(string_to_sign)
      digest = OpenSSL::Digest::SHA256.new
      OpenSSL::HMAC.hexdigest(digest, Config[:secret], string_to_sign)
    end

    def already_subscribed?
      Subscriptions.include? self
    end

    def app_key
      @data['auth'].split(':').first if @data['auth']
    end

    def signature
      @data['auth'].split(':').last if @data['auth']
    end
  end

  class SubscriptionError < Struct.new(:code, :message)
  end
end
