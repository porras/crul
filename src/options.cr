require "option_parser"
require "http/headers"
require "uri"
require "./methods"
require "./formatters"

module Crul
  class Options
    property :formatter, :method, :body, :headers
    property! :url

    def initialize
      @formatter = Formatters::Plain
      @method = Methods::GET
      @headers = HTTP::Headers.new
    end

    def self.parse(args)
      new.tap do |options|
        OptionParser.parse(args) do |parser|
          parser.banner = "Usage: crul [method] URL [options]"

          parser.on("get",    "GET",    "Use GET (default)") { options.method = Methods::GET    }
          parser.on("post",   "POST",   "Use POST")          { options.method = Methods::POST   }
          parser.on("put",    "PUT",    "Use PUT")           { options.method = Methods::PUT    }
          parser.on("delete", "DELETE", "Use DELETE")        { options.method = Methods::DELETE }

          parser.on("-d DATA", "--data DATA", "Request body") do |body|
            options.body = body
          end
          parser.on("-H HEADER", "--header HEADER", "Set header") do |header|
            name, value = header.split(":")
            options.headers[name] = value
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
            options.url = URI.parse(args.first)
          end
        end
      end
    end
  end
end
