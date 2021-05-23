require 'addressable/uri'
require 'http'
require 'link-header-parser'
require 'nokogiri'

require 'indieweb/endpoints/version'
require 'indieweb/endpoints/exceptions'

require 'indieweb/endpoints/services/response_parser_service'

require 'indieweb/endpoints/client'
require 'indieweb/endpoints/parsers'

require 'indieweb/endpoints/parsers/base_parser'
require 'indieweb/endpoints/parsers/authorization_endpoint_parser'
require 'indieweb/endpoints/parsers/micropub_parser'
require 'indieweb/endpoints/parsers/microsub_parser'
require 'indieweb/endpoints/parsers/redirect_uri_parser'
require 'indieweb/endpoints/parsers/token_endpoint_parser'
require 'indieweb/endpoints/parsers/webmention_parser'

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
