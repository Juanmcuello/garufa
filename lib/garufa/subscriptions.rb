require 'set'

module Garufa
  module Subscriptions
    extend self

    def all
      subscriptions
    end

    def add(subscription)
      subscriptions[subscription.channel].add subscription
    end

    def remove(subscription)
      subscriptions[subscription.channel].delete subscription
    end

    def notify(channels, event, options = {})
      return unless channels.is_a?(Array) && channels.any?

      channels.each do |channel|
        connections = subscriptions[channel].map { |s| s.connection }
        next unless connections.any?

        connections.each do |connection|
          next if connection.socket_id == options[:socket_id]

          message = Message.channel_event(channel, event, options[:data])
          connection.send_message(message)
        end
      end
    end

    def include?(subscription)
      subscriptions[subscription.channel].include? subscription
    end

    private

    def subscriptions
      @subscriptions ||= Hash.new(Set.new)
    end
  end

  class Subscription
    attr_reader :data, :connection, :error

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

    def channel_prefix
      channel[/^private-|presence-/].to_s[0...-1]
    end

    private

    def valid_channel?
      channel.is_a?(String) && !channel.empty?
    end

    def valid_app_key?
      app_key && app_key == Config[:app_key]
    end

    def valid_signature?
      string_to_sign = [@connection.socket_id, channel].compact.join(':')
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
