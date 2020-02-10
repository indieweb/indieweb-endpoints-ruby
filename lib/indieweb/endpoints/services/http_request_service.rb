module IndieWeb
  module Endpoints
    module Services
      class HttpRequestService
        HTTP_HEADERS_OPTS = {
          accept: '*/*',
          user_agent: 'IndieWeb Endpoint Discovery (https://rubygems.org/gems/indieweb-endpoints)'
        }.freeze

        # HTTP options derived from Webmention specification examples
        # https://www.w3.org/TR/webmention/#limits-on-get-requests
        def self.get(uri)
          HTTP.follow(max_hops: 20).headers(HTTP_HEADERS_OPTS).timeout(connect: 5, read: 5).get(uri)
        rescue HTTP::ConnectionError,
               HTTP::TimeoutError,
               HTTP::Redirector::TooManyRedirectsError => exception
          raise IndieWeb::Endpoints.const_get(exception.class.name.split('::').last), exception
        end
      end
    end
  end
end
