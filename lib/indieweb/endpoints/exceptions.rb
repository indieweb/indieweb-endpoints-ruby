# frozen_string_literal: true

module IndieWeb
  module Endpoints
    # Base error class.
    class Error < StandardError; end

    # Re-raises rescued exceptions originating from `Net::HTTP` responses.
    class HttpError < Error; end

    # Re-raises rescued `Addressable::URI::InvalidURIError`.
    class InvalidURIError < Error; end

    # Re-raises rescued `OpenSSL::OpenSSLError`.
    class SSLError < Error; end
  end
end
