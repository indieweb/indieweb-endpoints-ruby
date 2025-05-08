# frozen_string_literal: true

module IndieWeb
  module Endpoints
    class Client
      # Create a new client with a URL to parse for IndieWeb endpoints.
      #
      # @example
      #   client = IndieWeb::Endpoints::Client.new("https://aaronparecki.com")
      #
      # @param url [String, HTTP::URI, #to_s] an absolute URL
      #
      # @raise [InvalidURIError]
      def initialize(url)
        @uri = HTTP::URI.parse(url)
      rescue Addressable::URI::InvalidURIError => e
        raise InvalidURIError, e
      end

      # :nocov:
      # @return [String]
      def inspect
        format "#<%<class>s:%<id>#0x @uri=%<uri>s",
               class: self.class,
               id: object_id << 1,
               uri: uri.inspect
      end
      # :nocov:

      # A Hash of the discovered IndieWeb endpoints from the provided URL.
      #
      # @return [Hash{Symbol => String, Array, nil}]
      def endpoints
        @endpoints ||= Parser.new(response).to_h
      end

      # The +HTTP::Response+ object.
      #
      # @return [HTTP::Response]
      #
      # @raise [HttpError, SSLError]
      def response
        @response ||=
          HTTP
            .follow(max_hops: 20)
            .headers(accept: "*/*", user_agent: user_agent)
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

      # @return [String]
      def user_agent
        "Mozilla/5.0 (compatible; IndieWebEndpointsDiscovery/1.0; +https://rubygems.org/gems/indieweb-endpoints)"
      end
    end
  end
end
