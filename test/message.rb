require File.expand_path("helper", File.dirname(__FILE__))

module Garufa
  describe Message do
    describe '.connection_established' do
      before do
        @socket_id = '123123-123123'
        @message = Message.connection_established @socket_id
      end

      it 'should response with data attribute as string' do
        @message.data.class.must_equal String
      end

      it 'should response with expected event' do
        @message.event.must_equal 'pusher:connection_established'
      end

      it 'should response with expected data' do
        data = JSON.parse(@message.data)
        data["socket_id"].must_equal @socket_id
        data["activity_timeout"].must_equal 120
      end
    end

    describe '.channel_event' do
     before do
        @channel = 'channel-123'
        @event = 'my-event'
        @data = { itemId: 1, value: 'Sample Item' }
        @message = Message.channel_event @channel, @event, @data
      end

      it 'should response with expected event' do
        @message.event.must_equal @event
      end

      it 'should response with expected data' do
        @message.data.must_equal @data
      end

      it 'should response with expected channel' do
        @message.channel.must_equal @channel
      end
    end

    describe '.subscription_succeeded' do
      before do
        @channel = 'channel-123'
        @message = Message.subscription_succeeded @channel
      end

      it 'should response with expected event' do
        @message.event.must_equal 'pusher_internal:subscription_succeeded'
      end

      it 'should response with expected channel' do
        @message.channel.must_equal @channel
      end
    end

    describe '.pong' do
      it 'should response with a pong event' do
        Message.pong.event.must_equal 'pusher:pong'
      end
    end

    describe '.error' do
      before do
        @code, @error_message = 4000, 'There was an error!'
        @message = Message.error @code, @error_message
      end

      it 'should response with expected event' do
        @message.event.must_equal 'pusher:error'
      end

      it 'should response with expected data' do
        data = JSON.parse(@message.data)
        data["code"].must_equal @code
        data["message"].must_equal @error_message
      end
    end
  end
end
