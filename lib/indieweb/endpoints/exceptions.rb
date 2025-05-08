# frozen_string_literal: true

module IndieWeb
  module Endpoints
    class Error < StandardError; end

    class HttpError < Error; end

    class InvalidURIError < Error; end

    class SSLError < Error; end
  end
end
