module IndieWeb
  module Endpoints
    class Client
      HTTP_HEADERS_OPTS = {
        accept: '*/*',
        user_agent: 'IndieWeb Endpoint Discovery (https://rubygems.org/gems/indieweb-endpoints)'
      }.freeze

      # Create a new client with a URL to parse for IndieWeb endpoints
      #
      #   client = IndieWeb::Endpoints::Client.new('https://aaronparecki.com')
      #
      # @param url [String] an absolute URL
      def initialize(url)
        raise ArgumentError, "url must be a String (given #{url.class})" unless url.is_a?(String)

        @url = url

        raise ArgumentError, "url (#{url}) must be an absolute URL (e.g. https://example.com)" unless uri.absolute? && uri.scheme.match?(/^https?$/)
      end

      # @return [String]
      def inspect
        format(%(#<#{self.class.name}:%#0x url: #{url.inspect}>), object_id)
      end

      # @return [Hash{Symbol => String, Array, nil}]
      def endpoints
        @endpoints ||= Parsers.registered.transform_values { |parser| parser.new(response).results }
      end

      # @see https://www.w3.org/TR/webmention/#limits-on-get-requests
      #
      # @return [HTTP::Response]
      def response
        @response ||= HTTP.follow(max_hops: 20).headers(HTTP_HEADERS_OPTS).timeout(connect: 5, read: 5).get(uri)
      rescue HTTP::ConnectionError,
             HTTP::TimeoutError,
             HTTP::Redirector::TooManyRedirectsError => exception
        raise IndieWeb::Endpoints.const_get(exception.class.name.split('::').last), exception
      end

      private

      attr_accessor :url

      # @return [Addressable::URI]
      def uri
        @uri ||= Addressable::URI.parse(url)
      rescue Addressable::URI::InvalidURIError => exception
        raise InvalidURIError, exception
      end
    end
  end
end
