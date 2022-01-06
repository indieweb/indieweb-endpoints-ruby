# frozen_string_literal: true

module IndieWeb
  module Endpoints
    module Parsers
      class MicropubParser < BaseParser
        @identifier = :micropub

        Parsers.register(self)
      end
    end
  end
end
