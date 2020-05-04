module IndieWeb
  module Endpoints
    class Client
      def initialize(url)
        @uri = Addressable::URI.parse(url)

        raise ArgumentError, "url (#{url}) must be an absolute URL (e.g. https://example.com)" unless @uri.absolute? && @uri.scheme.match?(/^https?$/)
      rescue Addressable::URI::InvalidURIError => exception
        raise InvalidURIError, exception
      rescue NoMethodError, TypeError
        raise ArgumentError, "url must be a String (given #{url.class})"
      end

      def endpoints
        @endpoints ||= OpenStruct.new(Parsers.registered.transform_values { |parser| parser.new(response).results })
      end

      def response
        @response ||= Services::HttpRequestService.get(uri)
      end

      private

      attr_accessor :uri
    end
  end
end
