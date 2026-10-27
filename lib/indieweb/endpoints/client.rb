# frozen_string_literal: true

module IndieWeb
  module Endpoints
    # A client interface to parse IndieWeb endpoints from a URL.
    class Client
      # Set defaults derived from Webmention specification examples.
      #
      # @see https://www.w3.org/TR/webmention/#limits-on-get-requests
      #   W3C Webmention Recommendation § 4.2 Limits on GET requests
      HTTP_CLIENT_OPTS = {
        follow: {
          max_hops: 20,
        },
        headers: {
          accept: "*/*",
          user_agent: "Mozilla/5.0 (compatible; IndieWebEndpointsDiscovery/1.0; +https://rubygems.org/gems/indieweb-endpoints)",
        },
        timeout_options: {
          connect_timeout: 5,
          read_timeout: 5,
        },
      }.freeze

      private_constant :HTTP_CLIENT_OPTS

      # Create a new {Client} to parse a URL for IndieWeb endpoints.
      #
      # @example
      #   IndieWeb::Endpoints::Client.new("https://adactio.com")
      #
      # @param url [String, #to_s] An absolute URL.
      def initialize(url)
        @uri = HTTP::URI.parse(url)
      rescue Addressable::URI::InvalidURIError, HTTP::URI::InvalidError => e
        raise InvalidURIError, e
      end

      # @!visibility private
      # simplecov:disable
      def inspect
        "#<#{self.class}:#{format("%#0x", object_id)} @uri: #{@uri.inspect}>"
      end
      # simplecov:enable

      # The IndieWeb endpoints advertised by the provided URL.
      #
      # @example
      #   IndieWeb::Endpoints::Client.new("https://adactio.com").endpoints
      #
      # @raise (see #response)
      #
      # @return [Hash{Symbol => String, Array, nil}]
      def endpoints
        @endpoints ||= Parser.new(response).to_h
      end

      # The `HTTP::Response` object for the provided URL.
      #
      # @raise [HttpError, SSLError]
      #
      # @return [HTTP::Response]
      def response
        @response ||= client.request(:get, @uri)
      rescue HTTP::Error => e
        raise HttpError, e
      rescue OpenSSL::SSL::SSLError => e
        raise SSLError, e
      end

      private

      # @return [HTTP::Client]
      def client
        @client ||= HTTP::Client.new(HTTP_CLIENT_OPTS)
      end
    end
  end
end
