# frozen_string_literal: true

module IndieWeb
  module Endpoints
    module Parsers
      class AuthorizationEndpointParser < BaseParser
        @identifier = :authorization_endpoint

        Parsers.register(self)
      end
    end
  end
end
