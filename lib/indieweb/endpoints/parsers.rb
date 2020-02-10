module IndieWeb
  module Endpoints
    module Parsers
      def self.register(klass)
        registered[klass.identifier] = klass
      end

      def self.registered
        @registered ||= {}
      end
    end
  end
end
