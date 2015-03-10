require "option_parser"
require "uri"

module Crul
  class Options
    property :formatter, :method, :body
    property! :url

    def initialize
      @formatter = Formatters::Plain
      @method = "GET"
      @body = ""
    end

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
          parser.on("-d DATA", "--data DATA", "Request body") do |body|
            options.body = body
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
            options.url = URI.parse(args.first)
          end
        end
      end
    end
  end
end
