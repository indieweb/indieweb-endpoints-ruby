# frozen_string_literal: true

module IndieWeb
  module Endpoints
    class Client
      HTTP_HEADERS_OPTS = {
        accept: "*/*",
        user_agent: "IndieWeb Endpoint Discovery (https://rubygems.org/gems/indieweb-endpoints)",
      }.freeze

      private_constant :HTTP_HEADERS_OPTS

      # Create a new client with a URL to parse for IndieWeb endpoints.
      #
      # @example
      #   client = IndieWeb::Endpoints::Client.new("https://aaronparecki.com")
      #
      # @param url [String, HTTP::URI, #to_s] an absolute URL
      # @raise [IndieWeb::Endpoints::InvalidURIError]
      def initialize(url)
        @uri = HTTP::URI.parse(url.to_s)
      rescue Addressable::URI::InvalidURIError => e
        raise InvalidURIError, e
      end

      # @return [String]
      def inspect
        %(#<#{self.class.name}:#{format("%#0x", object_id)} uri: "#{uri}">)
      end

      # A Hash of the discovered IndieWeb endpoints from the provided URL.
      #
      # @return [Hash{Symbol => String, Array, nil}]
      def endpoints
        @endpoints ||= Parser.new(response).results
      end

      # The +HTTP::Response+ object returned by the provided URL.
      #
      # @return [HTTP::Response]
      # @raise [IndieWeb::Endpoints::HttpError, IndieWeb::Endpoints::SSLError]
      def response
        @response ||= HTTP
                        .follow(max_hops: 20)
                        .headers(HTTP_HEADERS_OPTS)
                        .timeout(connect: 5, read: 5)
                        .get(uri)
      rescue HTTP::Error => e
        raise HttpError, e
      rescue OpenSSL::SSL::SSLError => e
        raise SSLError, e
      end

      private

      # @return [HTTP::URI]
      attr_reader :uri
    end
  end
end
