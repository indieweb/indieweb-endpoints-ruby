module IndieWeb
  module Endpoints
    module Parsers
      class RedirectUriParser < BaseParser
        @identifier = :redirect_uri

        Parsers.register(self)

        # @return [Array<String>, nil]
        def results
          return unless mapped_results.any?

          mapped_results
        end
      end
    end
  end
end
