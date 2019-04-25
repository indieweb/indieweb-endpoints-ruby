module IndieWeb
  module Endpoints
    module Parsers
      class AuthorizationEndpointParser < BaseParser
        def self.identifier
          :authorization_endpoint
        end

        Parsers.register(self)
      end
    end
  end
end
