module IndieWeb
  module Endpoints
    class Request
      HTTP_HEADERS_OPTS = {
        accept: '*/*',
        user_agent: 'IndieWeb Endpoints Discovery (https://rubygems.org/gems/indieweb-endpoints)'
      }.freeze

      def initialize(url)
        raise ArgumentError, "url must be an Addressable::URI (given #{url.class.name})" unless url.is_a?(Addressable::URI)

        @url = url
      end

      def response
        @response ||= HTTP.follow.headers(HTTP_HEADERS_OPTS).timeout(
          connect: 10,
          read: 10
        ).get(@url)
      rescue HTTP::ConnectionError => exception
        raise ConnectionError, exception
      rescue HTTP::TimeoutError => exception
        raise TimeoutError, exception
      rescue HTTP::Redirector::TooManyRedirectsError => exception
        raise TooManyRedirectsError, exception
      end
    end
  end
end
