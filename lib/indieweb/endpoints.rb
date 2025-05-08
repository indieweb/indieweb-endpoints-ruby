# frozen_string_literal: true

require "http"
require "link-header-parser"
require "nokogiri/html-ext"

require_relative "endpoints/exceptions"

require_relative "endpoints/client"
require_relative "endpoints/parser"

module IndieWeb
  module Endpoints
    # Discover a URL's IndieAuth, Micropub, Microsub, and Webmention endpoints.
    #
    # Convenience method for {Client#endpoints}.
    #
    # @example
    #   IndieWeb::Endpoints.get("https://aaronparecki.com")
    #
    # @param (see Client#initialize)
    #
    # @return (see Client#endpoints)
    def self.get(url)
      Client.new(url).endpoints
    end
  end
end
