# frozen_string_literal: true

module IndieWeb
  module Endpoints
    # @api private
    class ResponseHeadersParser
      # @param response [HTTP::Response]
      def initialize(response)
        @headers = response.headers.get("link")
        @uri = response.uri
      end

      # @param identifier [Symbol]
      # @return [Array<String>]
      def results_for(identifier)
        # Reject endpoints that contain a fragment identifier
        Array(parsed_headers[identifier])
          .filter { |header| !HTTP::URI.parse(header.target_uri).fragment }
          .map(&:target_uri)
      end

      private

      # @return [Array<String>]
      attr_reader :headers

      # @return [HTTP::URI]
      attr_reader :uri

      # @return [Hash{Symbol => Array<LinkHeaderParser::LinkHeader>}]
      def parsed_headers
        @parsed_headers ||= LinkHeaderParser.parse(headers, base: uri).group_by_relation_type
      end
    end
  end
end
