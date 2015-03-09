require "option_parser"
require "uri"

module Crul
  class Options
    property :formatter

    def self.parse(args)
      new.tap do |options|
        OptionParser.parse(args) do |parser|
          parser.banner = "Usage: crul [options] URL"
          parser.on("-X METHOD", "--method METHOD", "Use GET|POST|PUT|DELETE (default: GET)") do |method|
            options.method = method
          end
          parser.on("-j", "--json", "Format response as JSON") do |method|
            options.formatter = Formatters::JSON
          end
          parser.on("-h", "--help", "Show this help") do
            puts parser
            exit
          end
          parser.unknown_args do |args|
            if args.empty?
              puts parser
              exit -1
            end
            options.url = args.first
          end
        end
      end
    end

    def method=(method)
      raise "Method #{method} not supported" unless %w(GET POST PUT DELETE).includes?(method.upcase)
      @method = method.upcase
    end

    def method
      @method || "GET"
    end

    def url=(url)
      @url = URI.parse(url)
    end

    def url
      @url.not_nil!
    end
  end
end
