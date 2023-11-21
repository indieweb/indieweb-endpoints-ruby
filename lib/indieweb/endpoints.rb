# frozen_string_literal: true

require "http"
require "link-header-parser"
require "nokogiri"

require_relative "endpoints/version"

require_relative "endpoints/client"
require_relative "endpoints/parser"
require_relative "endpoints/response_body_parser"
require_relative "endpoints/response_headers_parser"

module IndieWeb
  module Endpoints
    class Error < StandardError; end

    class HttpError < Error; end

    class InvalidURIError < Error; end

    class SSLError < Error; end

    # Discover a URL's IndieAuth, Micropub, Microsub, and Webmention endpoints.
    #
    # Convenience method for {IndieWeb::Endpoints::Client#endpoints}.
    #
    # @example
    #   IndieWeb::Endpoints.get('https://aaronparecki.com')
    #
    # @param (see IndieWeb::Endpoints::Client#endpoints)
    # @return (see IndieWeb::Endpoints::Client#endpoints)
    def self.get(url)
      Client.new(url).endpoints
    end
  end
end
