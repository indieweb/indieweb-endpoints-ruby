# frozen_string_literal: true

module IndieWeb
  module Endpoints
    module Parsers
      class MicrosubParser < BaseParser
        @identifier = :microsub

        Parsers.register(self)
      end
    end
  end
end
