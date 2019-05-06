module IndieWeb
  module Endpoints
    class HttpRequest
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

      def self.get(uri)
        HTTP::Client.new(HTTP_CLIENT_OPTS).request(:get, uri)
      rescue HTTP::ConnectionError,
             HTTP::TimeoutError,
             HTTP::Redirector::TooManyRedirectsError => exception
        raise IndieWeb::Endpoints.const_get(exception.class.name.split('::').last), exception
      end
    end
  end
end
