require_relative 'helper'

module Garufa
  describe Subscriptions do

    let(:channel) { 'channel1' }
    let(:data) { { 'channel' => channel } }

    describe '.remove' do

      before do
        @subscription = Subscription.new(data, nil)
        Subscriptions.add @subscription
      end

      it 'should remove subscription to channel' do
        count = Subscriptions.channel_size(channel)
        Subscriptions.remove @subscription
        Subscriptions.channel_size(channel).must_equal count - 1
      end
    end

    describe '.add' do

      before do
        @connection = MiniTest::Mock.new
        @connection.expect :socket_id, true
        @connection.expect :send_message, true, [Message]
      end

      it 'should add a new subscription to channel' do
        count = Subscriptions.channel_size(channel)
        Subscriptions.add Subscription.new(data, @connection)
        Subscriptions.channel_size(channel).must_equal count + 1
      end
    end

    describe '.notify' do

      let(:event) { 'my-event' }

      it 'should notify to subscribed subscriptions' do

        @connection = MiniTest::Mock.new
        @connection.expect :socket_id, true
        @connection.expect(:send_message, true) do |m|
          Message.channel_event(channel, event, nil).to_json == m.to_json
        end

        Subscriptions.add Subscription.new(data, @connection)
        Subscriptions.notify([channel], event)
        @connection.verify
      end
    end
  end
end
