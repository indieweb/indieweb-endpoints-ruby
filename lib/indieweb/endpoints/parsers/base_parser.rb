# frozen_string_literal: true

module IndieWeb
  module Endpoints
    module Parsers
      class BaseParser
        class << self
          attr_reader :identifier
        end

        # @param response [HTTP::Response]
        def initialize(response)
          raise ArgumentError, "response must be an HTTP::Response (given #{response.class.name})" unless response.is_a?(HTTP::Response)

          @response = response
        end

        # @return [String]
        def results
          mapped_results.shift
        end

        private

        attr_reader :response

        def mapped_results
          @mapped_results ||= results_from_http_request.map { |endpoint| Addressable::URI.join(response.uri, endpoint).to_s }.uniq.sort
        rescue Addressable::URI::InvalidURIError => e
          raise InvalidURIError, e
        end

        def parsed_response_body
          @parsed_response_body ||= Nokogiri::HTML(response.body.to_s)
        end

        def parsed_response_headers
          @parsed_response_headers ||= LinkHeaderParser.parse(response.headers.get('link'), base: response.uri)
        end

        def results_from_body
          return if response.mime_type != 'text/html'

          Services::ResponseParserService.parse_body(parsed_response_body, self.class.identifier)
        end

        def results_from_headers
          return if parsed_response_headers.none?

          Services::ResponseParserService.parse_headers(parsed_response_headers.group_by_relation_type, self.class.identifier)
        end

        def results_from_http_request
          @results_from_http_request ||= [results_from_headers, results_from_body].flatten.compact
        end
      end
    end
  end
end
