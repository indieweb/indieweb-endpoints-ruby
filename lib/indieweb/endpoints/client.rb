# frozen_string_literal: true

module IndieWeb
  module Endpoints
    # A client interface to parse IndieWeb endpoints from a URL.
    class Client
      # Create a new {Client} to parse a URL for IndieWeb endpoints.
      #
      # @example
      #   IndieWeb::Endpoints::Client.new("https://adactio.com")
      #
      # @param url [String, #to_s] An absolute URL.
      def initialize(url)
        @url = url
      end

      # @!visibility private
      # simplecov:disable
      def inspect
        "#<#{self.class}:#{format("%#0x", object_id)} @url: #{@url}>"
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
        @endpoints ||=
          Parser.new(
            body: response.body,
            headers: response.fetch("link", []),
            mime_type: response.content_type,
            uri: response.uri
          ).to_h
      end

      # The `Net::HTTPResponse` for the provided URL.
      #
      # @raise (see HTTP#get)
      #
      # @return (see HTTP#get)
      def response
        @response ||= HTTP.new(@url).fetch
      end
    end
  end
end
