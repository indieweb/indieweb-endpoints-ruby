module IndieWeb
  module Endpoints
    module Parsers
      class TokenEndpointParser < BaseParser
        def self.identifier
          :token_endpoint
        end

        Parsers.register(self)
      end
    end
  end
end
