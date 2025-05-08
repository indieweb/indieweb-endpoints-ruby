# frozen_string_literal: true

module IndieWeb
  module Endpoints
    # @api private
    class Parser
      # @param response [HTTP::Response]
      def initialize(response)
        @response = response
      end

      # @param identifier [String]
      # @param node_names [Array<String>]
      #
      # @return [Array<String>]
      #
      # @raise [InvalidURIError]
      def matches(identifier, node_names: ["link"])
        results = (matches_from_headers(identifier) + matches_from_body(identifier, node_names)).compact

        results.uniq!
        results.sort!

        results
      end

      # @param (see #matches)
      #
      # @return [String]
      def match(identifier, **kwargs)
        matches(identifier, **kwargs).first
      end

      # @return [Hash{Symbol => String, Array, nil}]
      def to_h
        {
          authorization_endpoint: match("authorization_endpoint"),
          "indieauth-metadata": match("indieauth-metadata"),
          micropub: match("micropub"),
          microsub: match("microsub"),
          redirect_uri: (redirect_uri = matches("redirect_uri")).any? ? redirect_uri : nil,
          token_endpoint: match("token_endpoint"),
          webmention: match("webmention", node_names: ["link", "a"]),
        }
      end

      private

      # @return [HTTP::Response]
      attr_reader :response

      # @return [Nokogiri::HTML5::Document]
      def body
        @body ||= Nokogiri::HTML5(response.body, response.uri).resolve_relative_urls!
      end

      # @return [Hash{Symbol => Array<LinkHeaderParser::LinkHeader>}]
      def headers
        @headers ||= LinkHeaderParser.parse(response.headers.get("link"), base_uri: response.uri).group_by_relation_type
      end

      # Reject URLs with fragment identifiers per the IndieAuth specification.
      #
      # @param identifier [String, #to_s]
      # @param node_names [Array<String, #to_s>]
      #
      # @return [Array<String>]
      def matches_from_body(identifier, node_names)
        return [] unless response.mime_type == "text/html"

        body
          .css(*node_names.map { |node| %(#{node}[rel~="#{identifier}"][href]:not([href*="#"]) / @href) })
          .map(&:value)
      end

      # Reject URLs with fragment identifiers per the IndieAuth specification.
      #
      # @param identifier [String, #to_sym]
      #
      # @return [Array<String>]
      def matches_from_headers(identifier)
        Array(headers[identifier]).filter_map do |header|
          header.target_uri unless HTTP::URI.parse(header.target_uri).fragment
        end
      end
    end
  end
end
