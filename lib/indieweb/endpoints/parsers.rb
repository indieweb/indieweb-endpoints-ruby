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
          BaseLinkElementParser.new(response, self.class.identifier).results
        end

        def results_from_headers
          BaseLinkHeaderParser.new(response, self.class.identifier).results
        end

        def results_from_http_request
          @results_from_http_request ||= results_from_headers || results_from_body || nil
        end

        class BaseLinkElementParser
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

        class BaseLinkHeaderParser
          attr_reader :identifier, :response

          def initialize(response, identifier)
            @response = response
            @identifier = identifier
          end

          def results
            return unless link_headers

            link_headers.shift.target_uri
          end

          private

          def link_headers
            @link_headers ||= begin
              return unless parsed_link_headers

              # Reject endpoints that contain a fragment identifier
              parsed_link_headers.reject { |parsed_link_header| Addressable::URI.parse(parsed_link_header.target_uri).fragment }
            end
          end

          def parsed_link_headers
            @parsed_link_headers ||= LinkHeaderParser.parse(response.headers.get('link'), base: response.uri.to_s).by_relation_type[identifier]
          end
        end
      end
    end
  end
end
