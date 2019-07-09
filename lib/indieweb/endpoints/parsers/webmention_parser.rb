module IndieWeb
  module Endpoints
    module Parsers
      class WebmentionParser < BaseParser
        def self.identifier
          :webmention
        end

        Parsers.register(self)
      end
    end
  end
end
