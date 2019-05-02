module IndieWeb
  module Endpoints
    class HttpRequest
      HTTP_HEADERS_OPTS = {
        accept: '*/*',
        user_agent: 'IndieAuth, Micropub, and Webmention Endpoint Discovery (https://rubygems.org/gems/indieweb-endpoints)'
      }.freeze

      def self.get(uri)
        HTTP.follow.headers(HTTP_HEADERS_OPTS).timeout(connect: 10, read: 10).get(uri)
      rescue HTTP::ConnectionError,
             HTTP::TimeoutError,
             HTTP::Redirector::TooManyRedirectsError => exception
        raise IndieWeb::Endpoints.const_get(exception.class.name.split('::').last), exception
      end
    end
  end
end
