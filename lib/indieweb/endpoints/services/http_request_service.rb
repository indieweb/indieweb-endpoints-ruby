module IndieWeb
  module Endpoints
    module Services
      class HttpRequestService
        # Defaults derived from Webmention specification examples
        # https://www.w3.org/TR/webmention/#limits-on-get-requests
        HTTP_CLIENT_OPTS = {
          follow: {
            max_hops: 20
          },
          headers: {
            accept: '*/*',
            user_agent: 'IndieWeb Endpoint Discovery (https://rubygems.org/gems/indieweb-endpoints)'
          },
          timeout_options: {
            connect_timeout: 5,
            read_timeout: 5
          }
        }.freeze

        def initialize
          @client = HTTP::Client.new(HTTP_CLIENT_OPTS)
        end

        def get(uri)
          client.request(:get, uri)
        rescue HTTP::ConnectionError,
               HTTP::TimeoutError,
               HTTP::Redirector::TooManyRedirectsError => exception
          raise IndieWeb::Endpoints.const_get(exception.class.name.split('::').last), exception
        end

        private

        attr_accessor :client
      end
    end
  end
end
