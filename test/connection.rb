require_relative 'helper'
require 'logger'

module Garufa

  describe Connection do
    include Garufa::Test::ConnectionHelpers

    before do
      @socket = MiniTest::Mock.new
      @connection = Connection.new(@socket, Logger.new('/dev/null'))
    end

    describe '.handle_incomming_data' do

      describe 'pusher:ping' do

        let(:data) { { event: 'pusher:ping', data: { channel: 'ch1' } } }

        it 'should response with pong' do
          message = Message.pong
          @socket.expect :send, true, [message.to_json]
          @connection.handle_incomming_data data.to_json
          @socket.verify
        end
      end

      describe 'pusher:subscribe' do

        let(:channel) { 'ch1' }
        let(:data) { { event: 'pusher:subscribe', data: { channel: channel } } }

        it 'should add a new Subscription to Subscriptions' do
          count = Subscriptions.channel_size(channel)
          @socket.expect :send, true, [String]
          @connection.handle_incomming_data data.to_json
          Subscriptions.channel_size(channel).must_equal count + 1
        end

        describe 'public channels' do
         it 'should response with subscription_succeeded' do
            message = Message.subscription_succeeded(data[:data][:channel])
            @socket.expect :send, true, [message.to_json]
            @connection.handle_incomming_data data.to_json
            @socket.verify
          end
        end

        describe 'private channels' do

          let(:channel) { 'private-ch1' }
          let(:app_key) { Config[:app_key] }
          let(:signature) { sign_string(@connection.socket_id, channel) }
          let(:data) { { event: 'pusher:subscribe', data: { channel: channel, auth: "#{app_key}:#{signature}" } } }

          it 'should response with subscription_succeeded' do
            message = Message.subscription_succeeded(channel)
            @socket.expect :send, true, [message.to_json]
            @connection.handle_incomming_data data.to_json
            @socket.verify
          end

          it 'should response with invalid channel' do
            data[:data][:channel] = ''
            message = Message.error(nil, 'Invalid channel')
            @socket.expect :send, true, [message.to_json]
            @connection.handle_incomming_data data.to_json
            @socket.verify
          end

          it 'should response with invalid signature' do
            data[:data][:auth] = "#{app_key}:invalid-signature"
            message = Message.error(nil, 'Invalid signature')
            @socket.expect :send, true, [message.to_json]
            @connection.handle_incomming_data data.to_json
            @socket.verify
          end

          it 'should response with invalid key' do
            data[:data][:auth] = "invalid-app-key:#{signature}"
            message = Message.error(nil, 'Invalid key')
            @socket.expect :send, true, [message.to_json]
            @connection.handle_incomming_data data.to_json
            @socket.verify
          end
        end
      end

      describe 'pusher:unsubscribe' do

        let(:channel) { 'ch1' }
        let(:data_subscribe) { { event: 'pusher:subscribe', data: { channel: channel } } }
        let(:data_unsubscribe) { { event: 'pusher:unsubscribe', data: { channel: channel } } }

        before do
          @socket.expect :send, true, [String]
          @connection.handle_incomming_data data_subscribe.to_json
        end

        it 'should remove Subscription from Subscriptions' do
          count = Subscriptions.channel_size(channel)
          @connection.handle_incomming_data data_unsubscribe.to_json
          Subscriptions.channel_size(channel).must_equal count - 1
        end

      end
    end
  end
end
