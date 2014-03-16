require File.expand_path("helper", File.dirname(__FILE__))
require 'logger'

module Garufa
  describe Connection do

    before do
      @socket = MiniTest::Mock.new
      @connection = Connection.new(@socket, Logger.new('/dev/null'))
    end

    describe '.handle_incomming_data' do

      describe 'pusher:subscribe' do

        before do
          @data = { event: 'pusher:subscribe', data: { channel: 'ch1' } }
        end

        it 'should add a new Subscription to Subscriptions' do
          @connection.handle_incomming_data @data.to_json
          Subscriptions.all['ch1'].first.class.must_equal Subscription
          Subscriptions.all['ch1'].count.must_equal 1
        end

        describe 'public channels' do
          it 'should not response with any message' do
            @socket.expect :send, true, [String]
            @connection.handle_incomming_data @data.to_json
            -> { @socket.verify }.must_raise(MockExpectationError, 'send should not be called')
          end
        end

        describe 'private channels' do

          before do
            @channel = 'private-ch1'
            @app_key = Config[:app_key]
            @signature = sign(@connection.socket_id, @channel)
            @data = { event: 'pusher:subscribe', data: { channel: @channel, auth: "#{@app_key}:#{@signature}" } }
          end

          it 'should response with subscription_succeeded' do
            message = Message.subscription_succeeded(@channel)
            @socket.expect :send, true, [message.to_json]
            @connection.handle_incomming_data @data.to_json
            @socket.verify
          end

          it 'should response with invalid channel' do
            @data[:data][:channel] = ''
            message = Message.error(nil, 'Invalid channel')
            @socket.expect :send, true, [message.to_json]
            @connection.handle_incomming_data @data.to_json
            @socket.verify
          end

          it 'should response with invalid signature' do
            @data[:data][:auth] = "#{@app_key}:invalid-signature"
            message = Message.error(nil, 'Invalid signature')
            @socket.expect :send, true, [message.to_json]
            @connection.handle_incomming_data @data.to_json
            @socket.verify
          end

          it 'should response with invalid key' do
            @data[:data][:auth] = "invalid-app-key:#{@signature}"
            message = Message.error(nil, 'Invalid key')
            @socket.expect :send, true, [message.to_json]
            @connection.handle_incomming_data @data.to_json
            @socket.verify
          end
        end
      end
    end
  end
end
