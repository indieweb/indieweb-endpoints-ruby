module IndieWeb
  module Endpoints
    module Parsers
      class AuthorizationEndpointParser < BaseParser
        Parsers.register(:authorization_endpoint, self)

        private

        def identifier
          @identifier ||= :authorization_endpoint
        end
      end
    end
  end
end
