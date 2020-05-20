module IndieWeb
  module Endpoints
    module Services
      class ResponseParserService
        # @param response [HTTP::Response]
        # @param identifier [Symbol]
        # @return [Array<String>]
        def self.parse_body(response, identifier, node = 'link')
          return unless response.mime_type == 'text/html'

          # Reject endpoints that contain a fragment identifier
          Nokogiri::HTML(response.body.to_s).css(%(#{node}[rel~="#{identifier}"][href]:not([href*="#"]))).map { |element| element['href'] }
        end

        # @param response [HTTP::Response]
        # @param identifier [Symbol]
        # @return [Array<String>]
        def self.parse_headers(response, identifier)
          headers = LinkHeaderParser.parse(response.headers.get('link'), base: response.uri.to_s).by_relation_type[identifier]

          return unless headers

          # Reject endpoints that contain a fragment identifier
          headers.reject { |header| Addressable::URI.parse(header.target_uri).fragment }.map(&:target_uri)
        end
      end
    end
  end
end
