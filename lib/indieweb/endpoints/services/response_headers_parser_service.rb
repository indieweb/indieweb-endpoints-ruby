module IndieWeb
  module Endpoints
    module Services
      class ResponseHeadersParserService
        def self.parse(response, identifier)
          headers = LinkHeaderParser.parse(response.headers.get('link'), base: response.uri.to_s).by_relation_type[identifier]

          return unless headers

          # Reject endpoints that contain a fragment identifier
          headers.reject { |header| Addressable::URI.parse(header.target_uri).fragment }.map(&:target_uri)
        end
      end
    end
  end
end
