module Crul
  module Formatters
    class Auto
      getter :formatter

      def initialize(output, response)
        content_type = response.headers.fetch("Content-type", "text/plain").split(';').first
        formatter_class = case content_type
                          when "application/json"
                            JSON
                          when "application/xml"
                            XML
                          else
                            Plain
                          end
        @formatter = formatter_class.new(output, response)
      end

      delegate print, @formatter
    end
  end
end
