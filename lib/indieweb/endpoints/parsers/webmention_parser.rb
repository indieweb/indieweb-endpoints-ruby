module IndieWeb
  module Endpoints
    module Parsers
      class WebmentionParser < BaseParser
        Parsers.register(:webmention, self)

        private

        def link_element
          # Search response body for first `a` or `link` element with valid `rel` and `href` attributes
          # https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint
          @link_element ||= doc.css(%([rel~="#{identifier}"][href])).find { |element| %w[a link].include?(element.name) }
        end

        def identifier
          @identifier ||= :webmention
        end
      end
    end
  end
end
