module IndieWeb
  module Endpoints
    class Client
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
        @response ||= Request.new(@url).response
      end
    end
  end
end
