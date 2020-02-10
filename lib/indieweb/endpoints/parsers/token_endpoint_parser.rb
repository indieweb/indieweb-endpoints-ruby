module IndieWeb
  module Endpoints
    module Parsers
      class TokenEndpointParser < BaseParser
        @identifier = :token_endpoint

        Parsers.register(self)
      end
    end
  end
end
