module IndieWeb
  module Endpoints
    module Parsers
      extend Registerable

      class BaseParser
        # Ultra-orthodox pattern matching allowed values in Link header `rel` parameter
        # https://tools.ietf.org/html/rfc8288#section-3.3
        REGEXP_REG_REL_TYPE_PATTERN = '[a-z\d][a-z\d\-\.]*'.freeze

        # Liberal pattern matching a string of text between angle brackets
        # https://tools.ietf.org/html/rfc5988#section-5.1
        REGEXP_TARGET_URI_PATTERN = /^<(.*)>;/.freeze

        def initialize(response)
          raise ArgumentError, "response must be an HTTP::Response (given #{response.class.name})" unless response.is_a?(HTTP::Response)

          @response = response
        end

        def results
          return unless results_from_http_request

          @results ||= Absolutely.to_absolute_uri(base: @response.uri.to_s, relative: results_from_http_request)
        rescue Absolutely::InvalidURIError => exception
          raise InvalidURIError, exception
        end

        private

        def discrete_link_headers
          # Split Link headers with multiple values, flatten the resulting array, and strip whitespace
          # https://webmention.rocks/test/19
          @discrete_link_headers ||= @response.headers.get('link').map { |header| header.split(',') }.flatten.map(&:strip)
        end

        def doc
          @doc ||= Nokogiri::HTML(@response.body.to_s)
        end

        def link_element
          # Return first `link` element with valid `rel` attribute
          # https://www.w3.org/TR/indieauth/#discovery-1
          # https://www.w3.org/TR/micropub/#endpoint-discovery
          @link_element ||= link_elements.shift
        end

        def link_elements
          @link_elements ||= doc.css(link_elements_css_selector)
        end

        def link_elements_css_selector
          @link_elements_css_selector ||= %(link[rel~="#{self.class.identifier}"][href])
        end

        def link_header
          @link_header ||= link_headers.shift
        end

        def link_headers
          # Reduce Link headers to those with valid `rel` attribute
          @link_headers ||= discrete_link_headers.find_all { |header| header.match?(regexp_rel_paramater_pattern) }
        end

        def regexp_rel_paramater_pattern
          # Ultra-orthodox pattern matching Link header `rel` parameter including a matching identifier value
          # https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint
          @regexp_rel_paramater_pattern ||= /(?:;|\s)rel="?(?:#{REGEXP_REG_REL_TYPE_PATTERN}+\s)?#{self.class.identifier}(?:\s#{REGEXP_REG_REL_TYPE_PATTERN})?"?/
        end

        def results_from_body
          link_element['href'] if response_is_html && link_element
        end

        def results_from_headers
          return unless link_header

          endpoint_match_data = link_header.match(REGEXP_TARGET_URI_PATTERN)

          return endpoint_match_data[1] if endpoint_match_data
        end

        def response_is_html
          @response_is_html ||= @response.mime_type == 'text/html'
        end

        def results_from_http_request
          @results_from_http_request ||= results_from_headers || results_from_body || nil
        end
      end
    end
  end
end
