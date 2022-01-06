require 'addressable/uri'
require 'http'
require 'link-header-parser'
require 'nokogiri'

require_relative 'endpoints/version'
require_relative 'endpoints/exceptions'

require_relative 'endpoints/services/response_parser_service'

require_relative 'endpoints/client'
require_relative 'endpoints/parsers'

require_relative 'endpoints/parsers/base_parser'
require_relative 'endpoints/parsers/authorization_endpoint_parser'
require_relative 'endpoints/parsers/micropub_parser'
require_relative 'endpoints/parsers/microsub_parser'
require_relative 'endpoints/parsers/redirect_uri_parser'
require_relative 'endpoints/parsers/token_endpoint_parser'
require_relative 'endpoints/parsers/webmention_parser'

module IndieWeb
  module Endpoints
    # Discover a URL's IndieAuth, Micropub, Microsub, and Webmention endpoints
    #
    #   IndieWeb::Endpoints.get('https://aaronparecki.com')
    #
    # @param url [String] an absolute URL
    # @return [Hash{Symbol => String, Array, nil}]
    def self.get(url)
      Client.new(url).endpoints
    end
  end
end
