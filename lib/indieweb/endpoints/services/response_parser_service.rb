module IndieWeb
  module Endpoints
    module Services
      class ResponseParserService
        # @param body [Nokogiri::HTML::Document]
        # @param identifier [Symbol]
        # @return [Array<String>]
        def self.parse_body(body, identifier, node = 'link')
          # Reject endpoints that contain a fragment identifier
          body.css(%(#{node}[rel~="#{identifier}"][href]:not([href*="#"]))).map { |element| element['href'] }
        end

        # @param headers [LinkHeaderParser::LinkHeadersCollection]
        # @param identifier [Symbol]
        # @return [Array<String>, nil]
        def self.parse_headers(headers, identifier)
          headers_for_identifier = headers.group_by_relation_type[identifier]

          return unless headers_for_identifier

          # Reject endpoints that contain a fragment identifier
          headers_for_identifier.reject { |header| Addressable::URI.parse(header.target_uri).fragment }.map(&:target_uri)
        end
      end
    end
  end
end
