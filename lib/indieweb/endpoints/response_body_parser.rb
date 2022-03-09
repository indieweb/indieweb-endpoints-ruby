# frozen_string_literal: true

module IndieWeb
  module Endpoints
    # @api private
    class ResponseBodyParser
      # @param response [HTTP::Response]
      def initialize(response)
        @body = response.body.to_s
        @mime_type = response.mime_type
        @uri = response.uri
      end

      # @param identifier [Symbol]
      # @param nodes [Array<String>]
      # @return [Array<string>, nil]
      def results_for(identifier, nodes = ['link'])
        return unless mime_type == 'text/html'

        # Reject endpoints that contain a fragment identifier
        selectors = nodes.map { |node| %(#{node}[rel~="#{identifier}"][href]:not([href*="#"])) }.join(',')

        parsed_body.css(selectors).map { |element| element['href'] }
      end

      private

      # @return [String]
      attr_reader :body

      # @return [String]
      attr_reader :mime_type

      # @return [HTTP::URI]
      attr_reader :uri

      # @return [Nokogiri::HTML5::Document]
      def parsed_body
        @parsed_body ||= Nokogiri::HTML5(body)
      end
    end
  end
end
