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

          @results ||= results_from_http_request.map { |endpoint| Absolutely.to_abs(base: response.uri.to_s, relative: endpoint) }.uniq.sort
        rescue Absolutely::InvalidURIError => exception
          raise InvalidURIError, exception
        end

        private

        def results_from_body
          RedirectUriLinkElementParser.new(response, self.class.identifier).results
        end

        def results_from_headers
          RedirectUriLinkHeaderParser.new(response, self.class.identifier).results
        end

        def results_from_http_request
          @results_from_http_request ||= [results_from_headers, results_from_body].flatten.compact
        end

        class RedirectUriLinkElementParser < BaseLinkElementParser
          def results
            link_elements.map { |element| element['href'] } if response_is_html && link_elements.any?
          end
        end

        class RedirectUriLinkHeaderParser < BaseLinkHeaderParser
          def results
            return unless link_headers

            link_headers.map(&:target_uri)
          end
        end
      end
    end
  end
end
