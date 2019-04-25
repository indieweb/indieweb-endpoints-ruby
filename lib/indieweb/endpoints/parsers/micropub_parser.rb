module IndieWeb
  module Endpoints
    module Parsers
      class MicropubParser < BaseParser
        def self.identifier
          :micropub
        end

        Parsers.register(self)
      end
    end
  end
end
