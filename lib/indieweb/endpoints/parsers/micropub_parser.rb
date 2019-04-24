module IndieWeb
  module Endpoints
    module Parsers
      class MicropubParser < BaseParser
        Parsers.register(:micropub, self)

        private

        def identifier
          @identifier ||= :micropub
        end
      end
    end
  end
end
