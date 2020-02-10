module IndieWeb
  module Endpoints
    module Services
      class ResponseBodyParserService
        def self.parse(response, identifier, node = 'link')
          return unless response.mime_type == 'text/html'

          # Reject endpoints that contain a fragment identifier
          Nokogiri::HTML(response.body.to_s).css(%(#{node}[rel~="#{identifier}"][href]:not([href*="#"]))).map { |element| element['href'] }
        end
      end
    end
  end
end
