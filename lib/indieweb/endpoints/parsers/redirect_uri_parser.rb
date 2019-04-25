module IndieWeb
  module Endpoints
    module Parsers
      class RedirectUriParser < BaseParser
        def self.identifier
          :redirect_uri
        end

        Parsers.register(self)

        def results
          return unless results_from_http_request.any?

          @results ||= results_from_http_request.map { |endpoint| Absolutely.to_absolute_uri(base: @response.uri.to_s, relative: endpoint) }.uniq.sort
        rescue Absolutely::InvalidURIError => exception
          raise InvalidURIError, exception
        end

        private

        def results_from_body
          link_elements.map { |element| element['href'] } if response_is_html && link_elements.any?
        end

        def results_from_headers
          return unless link_headers.any?

          link_headers.map do |header|
            endpoint_match_data = header.match(REGEXP_TARGET_URI_PATTERN)

            endpoint_match_data[1] if endpoint_match_data
          end
        end

        def results_from_http_request
          @results_from_http_request ||= [results_from_headers, results_from_body].flatten.compact
        end
      end
    end
  end
end
