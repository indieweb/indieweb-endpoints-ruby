module IndieWeb
  module Endpoints
    module Parsers
      class WebmentionParser < BaseParser
        Parsers.register(:webmention, self)

        private

        def identifier
          @identifier ||= :webmention
        end

        def link_element
          # Return first `a` or `link` element with valid `rel` attribute
          # https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint
          @link_element ||= link_elements.find { |element| %w[a link].include?(element.name) }
        end

        def link_elements_css_selector
          @link_elements_css_selector ||= %([rel~="#{identifier}"][href])
        end
      end
    end
  end
end
