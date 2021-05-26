module IndieWeb
  module Endpoints
    module Parsers
      class WebmentionParser < BaseParser
        @identifier = :webmention

        Parsers.register(self)

        private

        def results_for_node(node)
          Services::ResponseParserService.parse_body(parsed_response_body, self.class.identifier, node)
        end

        # https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint
        def results_from_body
          @results_from_body ||= [results_for_node('link'), results_for_node('a')].flatten.compact
        end
      end
    end
  end
end
