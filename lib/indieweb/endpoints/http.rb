# frozen_string_literal: true

module IndieWeb
  module Endpoints
    # A simple HTTP client to fetch a URL.
    #
    # @api private
    #
    # HTTP client defaults are derived from Webmention specification.
    #
    # @see https://www.w3.org/TR/webmention/#limits-on-get-requests
    #   W3C Webmention Recommendation § 4.2 Limits on GET requests
    class HTTP
      HTTP_CLIENT_OPTS = {
        open_timeout: 5,
        read_timeout: 5,
        ssl_timeout: 5,
      }.freeze

      HTTP_MAX_REDIRECTS = 20

      HTTP_REQUEST_HEADERS = {
        "accept" => "*/*",
        "user-agent" => "Mozilla/5.0 (compatible; IndieWebEndpointsDiscovery/1.0; +https://rubygems.org/gems/indieweb-endpoints)",
      }.freeze

      private_constant :HTTP_CLIENT_OPTS
      private_constant :HTTP_MAX_REDIRECTS
      private_constant :HTTP_REQUEST_HEADERS

      # @param uri [Addressable::URI]
      def initialize(uri)
        @redirects = 0
        @uri = uri
      end

      # @param uri [Addressable::URI, URI, String] An absolute URL.
      #
      # @raise [HttpError, InvalidURIError, SSLError]
      #
      # @return [Net::HTTPResponse]
      def fetch(uri = @uri)
        raise if @redirects > HTTP_MAX_REDIRECTS

        make_request(Addressable::URI.parse(uri).normalize!)
      rescue Addressable::URI::InvalidURIError => e
        raise InvalidURIError, e
      rescue OpenSSL::OpenSSLError => e
        raise SSLError, e
      rescue StandardError => e
        raise HttpError, e
      end

      private

      def handle_response(response)
        case response
        when Net::HTTPRedirection
          @redirects += 1
          fetch(response.uri.merge(response.fetch("location")))
        when Net::HTTPSuccess
          response
        else
          response.value
        end
      end

      def make_request(uri)
        Net::HTTP.start(uri.host, use_ssl: uri.scheme == "https", **HTTP_CLIENT_OPTS) do |http|
          handle_response(http.get(URI.parse(uri), HTTP_REQUEST_HEADERS))
        end
      end
    end
  end
end
