module IndieWeb
  module Endpoints
    module Parsers
      extend Registerable

      class BaseParser
        attr_reader :response

        def initialize(response)
          raise ArgumentError, "response must be an HTTP::Response (given #{response.class.name})" unless response.is_a?(HTTP::Response)

          @response = response
        end

        def results
          return unless results_from_http_request

          @results ||= Absolutely.to_abs(base: response.uri.to_s, relative: results_from_http_request)
        rescue Absolutely::InvalidURIError => exception
          raise InvalidURIError, exception
        end

        private

        def results_from_body
          LinkElementParser.new(response, self.class.identifier).results
        end

        def results_from_headers
          LinkHeaderParser.new(response, self.class.identifier).results
        end

        def results_from_http_request
          @results_from_http_request ||= results_from_headers || results_from_body || nil
        end
      end

      class LinkElementParser
        attr_reader :identifier, :response

        def initialize(response, identifier)
          @response = response
          @identifier = identifier
        end

        def results
          link_element['href'] if response_is_html && link_element
        end

        private

        def doc
          @doc ||= Nokogiri::HTML(response.body.to_s)
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
          @link_elements_css_selector ||= %(link[rel~="#{identifier}"][href]:not([href*="#"]))
        end

        def response_is_html
          @response_is_html ||= response.mime_type == 'text/html'
        end
      end

      class LinkHeaderParser
        # Ultra-orthodox pattern matching allowed values in Link header `rel` parameter
        # https://tools.ietf.org/html/rfc8288#section-3.3
        REGEXP_REG_REL_TYPE_PATTERN = '[a-z][a-z\d\.\-]*'.freeze

        # Liberal pattern capturing a string of text (excepting the octothorp) between angle brackets
        # https://tools.ietf.org/html/rfc8288#section-3.1
        REGEXP_TARGET_URI_PATTERN = '^<(.[^#]*)>;'.freeze

        attr_reader :identifier, :response

        def initialize(response, identifier)
          @response = response
          @identifier = identifier
        end

        def results
          return unless link_header

          endpoint_match_data = link_header.match(/#{REGEXP_TARGET_URI_PATTERN}/)

          return endpoint_match_data[1] if endpoint_match_data
        end

        private

        def discrete_link_headers
          # Split Link headers with multiple values, flatten the resulting array, and strip whitespace
          # https://webmention.rocks/test/19
          @discrete_link_headers ||= response.headers.get('link').map { |header| header.split(',') }.flatten.map(&:strip)
        end

        def link_header
          @link_header ||= link_headers.shift
        end

        def link_headers
          # Reduce Link headers to those with valid `rel` attribute
          @link_headers ||= discrete_link_headers.find_all { |header| header.match?(/#{REGEXP_TARGET_URI_PATTERN}\s*#{regexp_rel_paramater_pattern}/) }
        end

        def regexp_rel_paramater_pattern
          # Ultra-orthodox pattern matching Link header `rel` parameter including a matching identifier value
          # https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint
          @regexp_rel_paramater_pattern ||= %(rel="?(?:#{REGEXP_REG_REL_TYPE_PATTERN}+\s)?#{identifier}(?:\s#{REGEXP_REG_REL_TYPE_PATTERN})?"?)
        end
      end
    end
  end
end
