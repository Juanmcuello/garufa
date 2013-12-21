require File.expand_path("helper", File.dirname(__FILE__))

module Garufa
  describe Message do
    describe '.connection_established' do
      before do
        @message = Message.connection_established '123123-123123'
      end

      it 'should response with expected attributes' do
        @message.event.must_equal 'pusher:connection_established'
        @message.data.must_equal "{\"socket_id\":\"123123-123123\"}"
      end

      it 'should response with data attribute as string' do
        @message.data.class.must_equal String
      end
    end

    describe '.subscription_succeeded' do
      before do
        @channel = 'channel-123'
        @message = Message.subscription_succeeded @channel
      end

      it 'should response with expected attributes' do
        @message.event.must_equal 'pusher_internal:subscription_succeeded'
        @message.channel.must_equal @channel
      end
    end

    describe '.pong' do
      it 'should response with a pong event' do
        Message.pong.event.must_equal 'pusher:pong'
      end
    end

    describe '.error' do
    end

  end
end
