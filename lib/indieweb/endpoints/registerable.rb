module IndieWeb
  module Endpoints
    module Registerable
      def register(identifier, klass)
        registered[identifier] = klass
      end

      def registered
        @registered ||= {}
      end
    end
  end
end
