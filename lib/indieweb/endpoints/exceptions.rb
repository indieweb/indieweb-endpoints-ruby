module IndieWeb
  module Endpoints
    class ArgumentError < StandardError; end

    class ConnectionError < StandardError; end

    class InvalidURIError < StandardError; end

    class TimeoutError < StandardError; end

    class TooManyRedirectsError < StandardError; end
  end
end
