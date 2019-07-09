module IndieWeb
  module Endpoints
    module Services
      class ResponseBodyParserService
        def parse(response, identifier)
          return unless response.mime_type == 'text/html'

          # Reject endpoints that contain a fragment identifier
          # Return only `a` and `link` elements
          # https://www.w3.org/TR/webmention/#sender-discovers-receiver-webmention-endpoint
          Nokogiri::HTML(response.body.to_s).css(%([rel~="#{identifier}"][href]:not([href*="#"]))).find_all { |element| %w[a link].include?(element.name) }.map { |element| element['href'] }
        end
      end
    end
  end
end
