require_relative 'helper'

module Garufa

  describe API do
    include Rack::Test::Methods
    include Garufa::Test::RackHelpers

    def app
      API::Server
    end

    let(:app_id) { Garufa::Config[:app_id] }
    let(:uri)    { URI.parse("/apps/#{app_id}") }

    describe 'Authentication' do
      describe 'When app_id is invalid' do

        let(:app_id) { "invalid-app-id" }

        it 'should return 400 status code' do
          signed_post uri
          last_response.status.must_equal 400
        end

        it 'should response with error message' do
          signed_post uri
          message = "Token validated, but invalid for app #{app_id}"
          last_response.body.must_equal message
        end
      end

      describe 'When request is not signed' do
        it 'should return 401 status code' do
          post uri.path
          last_response.status.must_equal 401
        end
      end

      describe 'When request is signed' do
        it 'should not return 401 status code' do
          signed_post uri
          last_response.status.wont_equal 401
        end
      end
    end

    describe 'events triggering' do

      let(:handler) { Minitest::Mock.new }

      describe 'requests to /events' do

        let(:uri) { URI.parse("/apps/#{app_id}/events") }

        before do
          handler.expect :handle, nil, [String]
        end

        it 'should handle events' do
          API::EventHandler.stub :new, handler do
            signed_post uri
            handler.verify
          end
        end

        it 'should response 202 status code' do
          API::EventHandler.stub :new, handler do
            signed_post uri
            last_response.status.must_equal 200
          end
        end

        it 'should response empty json object' do
          API::EventHandler.stub :new, handler do
            signed_post uri
            last_response.body.must_equal '{}'
          end
        end
      end

      describe '/channels/:channel/events' do

        let(:channel) { 'channel-1' }
        let(:uri)     { URI.parse("/apps/#{app_id}/channels/#{channel}/events") }

        before do
          handler.expect :handle_legacy, nil, [String, channel, Hash]
        end

        it 'should handle legacy events' do
          API::EventHandler.stub :new, handler do
            signed_post uri
            handler.verify
          end
        end

        it 'should response 202 status code' do
          API::EventHandler.stub :new, handler do
            signed_post uri
            last_response.status.must_equal 202
          end
        end

        it 'should response empty json object' do
          API::EventHandler.stub :new, handler do
            signed_post uri
            last_response.body.must_equal '{}'
          end
        end
      end
    end

    describe 'When getting channels info' do

      let(:uri) { URI.parse("/apps/#{app_id}/channels") }

      describe 'requests to /channels' do
        it 'should response 200 status code' do
          signed_get uri
          last_response.status.must_equal 200
        end

        it 'should response with valid JSON' do
          signed_get uri
          JSON.parse(last_response.body).must_be_kind_of Hash
        end
      end

      describe 'requests to /channels/presence-channel-1' do
        it 'should response 200 status code' do
          uri.path += '/presence-channel-1'
          signed_get uri
          last_response.status.must_equal 200
        end

        it 'should response with valid JSON' do
          signed_get uri
          uri.path += '/presence-channel-1'
          signed_get uri
          JSON.parse(last_response.body).must_be_kind_of Hash
        end

      end

      describe 'requests to /channels/presence-channel-1/users' do
        it 'should response 200 status code' do
          uri.path += '/presence-channel-1/users'
          signed_get uri
          last_response.status.must_equal 200
        end
      end

      describe 'requests to /channels/non-presence-channel-1' do
        it 'should response 200 status code' do
          uri.path += '/non-presence-channel-1'
          signed_get uri
          last_response.status.must_equal 200
        end
      end

      describe 'requests to /channel-1/users' do
        it 'should response 200 status code' do
          uri.path += '/channel-1/users'
          signed_get uri
          last_response.status.must_equal 400
        end
      end
    end
  end
end
