module IndieWeb
  module Endpoints
    class Error < StandardError; end

    class ArgumentError < Error; end

    class HttpError < Error; end

    class InvalidURIError < Error; end
  end
end
