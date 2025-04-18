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
        results =
          (matches_from_headers(identifier) + matches_from_body(identifier, node_names))
            .compact
            .map! { |endpoint| response.uri.join(endpoint).to_s }

        results.uniq!
        results.sort!

        results
      rescue Addressable::URI::InvalidURIError => e
        raise InvalidURIError, e
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
        @body ||= Nokogiri::HTML5(response.body)
      end

      # @return [Hash{Symbol => Array<LinkHeaderParser::LinkHeader>}]
      def headers
        @headers ||= LinkHeaderParser.parse(response.headers.get("link"), base: response.uri).group_by_relation_type
      end

      # @return [Array<String>]
      def matches_from_body(identifier, node_names)
        return [] unless response.mime_type == "text/html"

        # Reject endpoints that contain a fragment identifier.
        selectors = node_names.map { |node| %(#{node}[rel~="#{identifier}"][href]:not([href*="#"])) }.join(",")

        body.css(selectors).map { |element| element["href"] }
      end

      # @return [Array<String>]
      def matches_from_headers(identifier)
        # Reject endpoints that contain a fragment identifier.
        Array(headers[identifier.to_sym])
          .filter { |header| !HTTP::URI.parse(header.target_uri).fragment }
          .map(&:target_uri)
      end
    end
  end
end
