require File.expand_path("helper", File.dirname(__FILE__))

module Garufa
  describe Message do
    describe '.connection_established' do

      let(:socket_id) { '123123-123123' }

      before do
        @message = Message.connection_established socket_id
      end

      it 'should response with data attribute as string' do
        @message.data.class.must_equal String
      end

      it 'should response with expected event' do
        @message.event.must_equal 'pusher:connection_established'
      end

      it 'should response with expected data' do
        data = JSON.parse(@message.data)
        data["socket_id"].must_equal socket_id
        data["activity_timeout"].must_equal 120
      end
    end

    describe '.channel_event' do

      let(:channel) { 'channel-123' }
      let(:event) { 'my-event' }
      let(:data) { { itemId: 1, value: 'Sample Item' } }

      before do
        @message = Message.channel_event channel, event, data
      end

      it 'should response with expected event' do
        @message.event.must_equal event
      end

      it 'should response with expected data' do
        @message.data.must_equal data
      end

      it 'should response with expected channel' do
        @message.channel.must_equal channel
      end
    end

    describe '.subscription_succeeded' do

      let(:channel) { 'channel-123' }

      before do
        @message = Message.subscription_succeeded channel
      end

      it 'should response with expected event' do
        @message.event.must_equal 'pusher_internal:subscription_succeeded'
      end

      it 'should response with expected channel' do
        @message.channel.must_equal channel
      end

      it 'should response with empty data' do
        @message.data.must_equal({})
      end
    end

    describe '.pong' do

      before do
        @message = Message.pong
      end

      it 'should response with expected event' do
        @message.event.must_equal 'pusher:pong'
      end

      it 'should response with empty data' do
        @message.data.must_equal({})
      end
    end

    describe '.error' do

      let(:code) { 4000 }
      let(:error_message) { 'There was an error!' }

      before do
        @message = Message.error code, error_message
      end

      it 'should response with expected event' do
        @message.event.must_equal 'pusher:error'
      end

      it 'should response with expected data' do
        data = JSON.parse(@message.data)
        data["code"].must_equal code
        data["message"].must_equal error_message
      end
    end
  end
end
