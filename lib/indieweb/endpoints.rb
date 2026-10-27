# frozen_string_literal: true

require "http"
require "link-header-parser"
require "nokogiri/html-ext"

require_relative "endpoints/exceptions"
require_relative "endpoints/client"
require_relative "endpoints/parser"

# Welcome to the IndieWeb, a people-focused alternative to the "corporate web."
#
# @see https://indieweb.org
module IndieWeb
  # @see https://indieweb.org/endpoint
  module Endpoints
    # Discover a URL's IndieAuth, Micropub, Microsub, and Webmention endpoints.
    #
    # Convenience method for {Client#endpoints}.
    #
    # @example
    #   IndieWeb::Endpoints.get("https://adactio.com")
    #
    # @param (see Client#initialize)
    #
    # @raise (see Client#endpoints)
    #
    # @return (see Client#endpoints)
    def self.get(url)
      Client.new(url).endpoints
    end
  end
end
