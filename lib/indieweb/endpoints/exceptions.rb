module IndieWeb
  module Endpoints
    class IndieWebEndpointsError < StandardError; end

    class ArgumentError < IndieWebEndpointsError; end

    class ConnectionError < IndieWebEndpointsError; end

    class InvalidURIError < IndieWebEndpointsError; end

    class TimeoutError < IndieWebEndpointsError; end

    class TooManyRedirectsError < IndieWebEndpointsError; end
  end
end
