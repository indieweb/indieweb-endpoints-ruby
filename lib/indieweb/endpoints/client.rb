# frozen_string_literal: true

module IndieWeb
  module Endpoints
    class Client
      HTTP_HEADERS_OPTS = {
        accept: '*/*',
        user_agent: 'IndieWeb Endpoint Discovery (https://rubygems.org/gems/indieweb-endpoints)'
      }.freeze

      # Create a new client with a URL to parse for IndieWeb endpoints
      #
      #   client = IndieWeb::Endpoints::Client.new('https://aaronparecki.com')
      #
      # @param url [String] an absolute URL
      def initialize(url)
        @url = url.to_str
      end

      # @return [String]
      def inspect
        "#<#{self.class.name}:#{format('%#0x', object_id)} url: #{url.inspect}>"
      end

      # @return [Hash{Symbol => String, Array, nil}]
      def endpoints
        @endpoints ||= Parsers.registered.transform_values { |parser| parser.new(response).results }
      end

      # @see https://www.w3.org/TR/webmention/#limits-on-get-requests
      #
      # @return [HTTP::Response]
      def response
        @response ||= HTTP.follow(max_hops: 20).headers(HTTP_HEADERS_OPTS).timeout(connect: 5, read: 5).get(uri)
      rescue HTTP::Error => e
        raise HttpError, e
      end

      private

      attr_accessor :url

      def uri
        @uri ||= Addressable::URI.parse(url)
      rescue Addressable::URI::InvalidURIError => e
        raise InvalidURIError, e
      end
    end
  end
end
