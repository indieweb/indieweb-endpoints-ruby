require 'ostruct'

require 'absolutely'
require 'addressable/uri'
require 'http'
require 'nokogiri'

require 'indieweb/endpoints/version'
require 'indieweb/endpoints/exceptions'

require 'indieweb/endpoints/client'
require 'indieweb/endpoints/http_request'
require 'indieweb/endpoints/registerable'

require 'indieweb/endpoints/parsers'
require 'indieweb/endpoints/parsers/authorization_endpoint_parser'
require 'indieweb/endpoints/parsers/micropub_parser'
require 'indieweb/endpoints/parsers/microsub_parser'
require 'indieweb/endpoints/parsers/redirect_uri_parser'
require 'indieweb/endpoints/parsers/token_endpoint_parser'
require 'indieweb/endpoints/parsers/webmention_parser'

module IndieWeb
  module Endpoints
    class << self
      def client(url)
        Client.new(url)
      end

      def get(url)
        client(url).endpoints
      end
    end
  end
end
