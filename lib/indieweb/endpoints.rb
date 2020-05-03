require 'ostruct'

require 'absolutely'
require 'addressable/uri'
require 'http'
require 'link-header-parser'
require 'nokogiri'

require 'indieweb/endpoints/version'
require 'indieweb/endpoints/exceptions'

require 'indieweb/endpoints/services/http_request_service'
require 'indieweb/endpoints/services/response_body_parser_service'
require 'indieweb/endpoints/services/response_headers_parser_service'

require 'indieweb/endpoints/client'
require 'indieweb/endpoints/parsers'

require 'indieweb/endpoints/parsers/base_parser'
require 'indieweb/endpoints/parsers/authorization_endpoint_parser'
require 'indieweb/endpoints/parsers/micropub_parser'
require 'indieweb/endpoints/parsers/microsub_parser'
require 'indieweb/endpoints/parsers/redirect_uri_parser'
require 'indieweb/endpoints/parsers/token_endpoint_parser'
require 'indieweb/endpoints/parsers/webmention_parser'
require 'indieweb/endpoints/parsers/pingback_parser'

module IndieWeb
  module Endpoints
    def self.get(url)
      Client.new(url).endpoints
    end
  end
end
