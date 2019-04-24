module IndieWeb
  module Endpoints
    module Parsers
      class TokenEndpointParser < BaseParser
        Parsers.register(:token_endpoint, self)

        private

        def identifier
          @identifier ||= :token_endpoint
        end
      end
    end
  end
end
