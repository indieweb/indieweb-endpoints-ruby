# frozen_string_literal: true

module IndieWeb
  module Endpoints
    class HttpError < StandardError; end
    class InvalidURIError < StandardError; end
    class SSLError < StandardError; end
  end
end
