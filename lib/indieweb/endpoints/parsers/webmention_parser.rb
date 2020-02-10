module IndieWeb
  module Endpoints
    module Parsers
      class WebmentionParser < BaseParser
        def self.identifier
          :webmention
        end

        Parsers.register(self)

        private

        def results_for_node(node)
          Services::ResponseBodyParserService.parse(response, self.class.identifier, node)
        end

        # https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint
        def results_from_body
          @results_from_body ||= [results_for_node('link'), results_for_node('a')].flatten.compact
        end
      end
    end
  end
end
