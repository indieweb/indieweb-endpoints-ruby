module IndieWeb
  module Endpoints
    class Client
      HTTP_HEADERS_OPTS = {
        accept: '*/*',
        user_agent: 'IndieAuth, Micropub, and Webmention Endpoint Discovery (https://rubygems.org/gems/indieweb-endpoints)'
      }.freeze

      def initialize(url)
        raise ArgumentError, "url must be a String (given #{url.class.name})" unless url.is_a?(String)

        @url = Addressable::URI.parse(url)

        raise ArgumentError, 'url must be an absolute URL (e.g. https://example.com)' unless @url.absolute?
      rescue Addressable::URI::InvalidURIError => exception
        raise InvalidURIError, exception
      end

      def endpoints
        @endpoints ||= Parsers.registered.transform_values { |parser| parser.new(response).results }
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
