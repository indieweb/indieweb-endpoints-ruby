# frozen_string_literal: true

module IndieWeb
  module Endpoints
    # @api private
    class Parser
      # @param response [HTTP::Response]
      def initialize(response)
        @response = response
      end

      # @return [Hash{Symbol => String, Array<String>, nil}]
      def results
        {
          authorization_endpoint: result_for(:authorization_endpoint),
          'indieauth-metadata': result_for(:'indieauth-metadata'),
          micropub: result_for(:micropub),
          microsub: result_for(:microsub),
          redirect_uri: results_for(:redirect_uri),
          token_endpoint: result_for(:token_endpoint),
          webmention: result_for(:webmention, %w[link a])
        }
      end

      private

      # @return [HTTP::Response]
      attr_reader :response

      # @return [IndieWeb::Endpoints::ResponseBodyParser]
      def response_body_parser
        @response_body_parser ||= ResponseBodyParser.new(response)
      end

      # @return [IndieWeb::Endpoints::ResponseHeadersParser]
      def response_headers_parser
        @response_headers_parser ||= ResponseHeadersParser.new(response)
      end

      # @param identifier [Symbol]
      # @param nodes [Array<String>]
      # @return [String, nil]
      def result_for(identifier, nodes = ['link'])
        results_for(identifier, nodes)&.first
      end

      # @param identifier [Symbol]
      # @param nodes [Array<String>]
      # @return [Array<String>, nil]
      # @raise [IndieWeb::Endpoints::InvalidURIError]
      def results_for(identifier, nodes = ['link'])
        results_from_request = [
          response_headers_parser.results_for(identifier),
          response_body_parser.results_for(identifier, nodes)
        ].flatten.compact

        return if results_from_request.none?

        results_from_request.map { |endpoint| response.uri.join(endpoint).to_s }.uniq.sort
      rescue Addressable::URI::InvalidURIError => e
        raise InvalidURIError, e
      end
    end
  end
end
