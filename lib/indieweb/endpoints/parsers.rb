module IndieWeb
  module Endpoints
    module Parsers
      def self.register(identifier, klass)
        registered[identifier] = klass
      end

      def self.registered
        @registered ||= {}
      end

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
          return unless endpoint_from_http_request

          @results ||= Absolutely.to_absolute_uri(base: @response.uri.to_s, relative: endpoint_from_http_request)
        rescue Absolutely::InvalidURIError => exception
          raise InvalidURIError, exception
        end

        private

        def doc
          @doc ||= Nokogiri::HTML(@response.body.to_s)
        end

        def endpoint_from_body
          return unless @response.mime_type == 'text/html' && link_element

          link_element['href']
        end

        def endpoint_from_headers
          return unless link_header

          endpoint_match_data = link_header.match(REGEXP_TARGET_URI_PATTERN)

          return endpoint_match_data[1] if endpoint_match_data
        end

        def endpoint_from_http_request
          @endpoint_from_http_request ||= endpoint_from_headers || endpoint_from_body || nil
        end

        def link_element
          # Search response body for first `link` element with valid `rel` attribute
          # https://www.w3.org/TR/indieauth/#discovery-1
          # https://www.w3.org/TR/micropub/#endpoint-discovery
          @link_element ||= doc.css(%(link[rel~="#{identifier}"][href])).shift
        end

        def link_header
          @link_header ||= link_headers.find { |header| header.match?(regexp_rel_paramater_pattern) }
        end

        def link_headers
          # Split Link headers with multiple values, flatten the resulting array, and strip whitespace
          # https://webmention.rocks/test/19
          @link_headers ||= @response.headers.get('link').map { |header| header.split(',') }.flatten.map(&:strip)
        end

        def regexp_rel_paramater_pattern
          # Ultra-orthodox pattern matching Link header `rel` parameter including a matching identifier value
          # https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint
          @regexp_rel_paramater_pattern ||= /(?:;|\s)rel="?(?:#{REGEXP_REG_REL_TYPE_PATTERN}+\s)?#{identifier}(?:\s#{REGEXP_REG_REL_TYPE_PATTERN})?"?/
        end
      end
    end
  end
end
