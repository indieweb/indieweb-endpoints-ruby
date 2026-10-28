# frozen_string_literal: true

module IndieWeb
  module Endpoints
    # A parser for extracting IndieWeb endpoints from an HTTP response's headers
    # and body.
    class Parser
      # @param body [String, #to_s]
      # @param headers [Array<String>]
      # @param mime_type [String, #to_s]
      # @param uri [Addressable::URI, URI, #to_s]
      def initialize(body: "", headers: [], mime_type: "text/html", uri: "")
        @body = Nokogiri::HTML5(body.to_s, uri.to_s).resolve_urls!
        @headers = LinkHeaderParser.parse(Array(headers), base_uri: uri).group_by_relation_type
        @mime_type = mime_type.to_s
      end

      # @param identifier [String]
      # @param node_names [Array<String>]
      #
      # @raise [InvalidURIError]
      #
      # @return [Array<String>]
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

      # Reject URLs with fragment identifiers per the IndieAuth specification.
      #
      # @param identifier [String, #to_s]
      # @param node_names [Array<String, #to_s>]
      #
      # @return [Array<String>]
      def matches_from_body(identifier, node_names)
        return [] unless @mime_type == "text/html"

        @body
          .css(*node_names.map { |node| %(#{node}[rel~="#{identifier}"][href]:not([href*="#"]) / @href) })
          .map(&:value)
      end

      # Reject URLs with fragment identifiers per the IndieAuth specification.
      #
      # @param identifier [String, #to_sym]
      #
      # @raise [InvalidURIError]
      #
      # @return [Array<String>]
      def matches_from_headers(identifier)
        Array(@headers[identifier]).filter_map do |header|
          header.target_uri unless Addressable::URI.parse(header.target_uri).fragment
        end
      rescue Addressable::URI::InvalidURIError => e
        raise InvalidURIError, e
      end
    end
  end
end
