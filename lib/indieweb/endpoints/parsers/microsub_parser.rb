module IndieWeb
  module Endpoints
    module Parsers
      class MicrosubParser < BaseParser
        def self.identifier
          :microsub
        end

        Parsers.register(self)
      end
    end
  end
end
