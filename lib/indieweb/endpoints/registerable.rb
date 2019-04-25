module IndieWeb
  module Endpoints
    module Registerable
      def register(klass)
        registered[klass.identifier] = klass
      end

      def registered
        @registered ||= {}
      end
    end
  end
end
