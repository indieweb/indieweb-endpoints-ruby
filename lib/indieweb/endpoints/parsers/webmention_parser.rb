module IndieWeb
  module Endpoints
    module Parsers
      class WebmentionParser < BaseParser
        def self.identifier
          :webmention
        end

        Parsers.register(self)

        private

        def link_element
          # Return first `a` or `link` element with valid `rel` attribute
          # https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint
          @link_element ||= link_elements.find { |element| %w[a link].include?(element.name) }
        end

        def link_elements_css_selector
          @link_elements_css_selector ||= %([rel~="#{self.class.identifier}"][href])
        end
      end
    end
  end
end
