require 'absolutely'
require 'addressable/uri'
require 'http'
require 'nokogiri'

require 'indieweb/endpoints/version'
require 'indieweb/endpoints/exceptions'

require 'indieweb/endpoints/client'
require 'indieweb/endpoints/parsers'
require 'indieweb/endpoints/parsers/authorization_endpoint_parser'
require 'indieweb/endpoints/parsers/micropub_parser'
require 'indieweb/endpoints/parsers/token_endpoint_parser'
require 'indieweb/endpoints/parsers/webmention_parser'

module IndieWeb
  module Endpoints
    def self.get(url)
      Client.new(url).endpoints
    end
  end
end
