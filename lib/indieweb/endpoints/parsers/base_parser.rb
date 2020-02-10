module IndieWeb
  module Endpoints
    module Parsers
      class BaseParser
        class << self
          attr_reader :identifier
        end

        def initialize(response)
          raise ArgumentError, "response must be an HTTP::Response (given #{response.class.name})" unless response.is_a?(HTTP::Response)

          @response = response
        end

        def results
          mapped_results.shift
        end

        private

        attr_reader :response

        def mapped_results
          @mapped_results ||= results_from_http_request.map { |endpoint| Absolutely.to_abs(base: response.uri.to_s, relative: endpoint) }.uniq.sort
        rescue Absolutely::InvalidURIError => exception
          raise InvalidURIError, exception
        end

        def results_from_body
          @results_from_body ||= Services::ResponseBodyParserService.parse(response, self.class.identifier)
        end

        def results_from_headers
          @results_from_headers ||= Services::ResponseHeadersParserService.parse(response, self.class.identifier)
        end

        def results_from_http_request
          @results_from_http_request ||= [results_from_headers, results_from_body].flatten.compact
        end
      end
    end
  end
end
