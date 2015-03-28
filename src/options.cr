require "option_parser"
require "./option_parser_fix"
require "http/headers"
require "uri"
require "./methods"
require "./formatters"

module Crul
  class Options
    property :formatter, :method, :body, :headers
    property :basic_auth
    property! :url

    def initialize
      @formatter = Formatters::Auto
      @method = Methods::GET
      @headers = HTTP::Headers.new
    end

    def self.parse(args)
      new.tap do |options|
        OptionParser.parse(args) do |parser|
          parser.banner = "Usage: crul [method] URL [options]"

          parser.separator
          parser.separator "HTTP methods (default: GET):"
          parser.on("get",    "GET",    "Use GET")    { options.method = Methods::GET    }
          parser.on("post",   "POST",   "Use POST")   { options.method = Methods::POST   }
          parser.on("put",    "PUT",    "Use PUT")    { options.method = Methods::PUT    }
          parser.on("delete", "DELETE", "Use DELETE") { options.method = Methods::DELETE }

          parser.separator
          parser.separator "HTTP options:"
          parser.on("-d DATA", "--data DATA", "Request body") do |body|
            options.body = if body.starts_with?('@')
              File.read(body[1..-1])
            else
              body
            end
          end
          parser.on("-d @file", "--data @file", "Request body (read from file)") {} # previous handler
          parser.on("-H HEADER", "--header HEADER", "Set header") do |header|
            name, value = header.split(':', 2)
            options.headers[name] = value
          end
          parser.on("-a USER:PASS", "--auth USER:PASS", "Basic auth") do |user_pass|
            pieces = user_pass.split(':', 2)
            options.basic_auth = {pieces[0], pieces[1]? || ""}
          end

          parser.separator
          parser.separator "Response formats (default: autodetect):"
          parser.on("-j", "--json", "Format response as JSON") do |method|
            options.formatter = Formatters::JSON
          end
          parser.on("-x", "--xml", "Format response as XML") do |method|
            options.formatter = Formatters::XML
          end
          parser.on("-p", "--plain", "Format response as plain text") do |method|
            options.formatter = Formatters::Plain
          end

          parser.separator
          parser.separator "Other options:"
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

          parser.separator
        end
      end
    end
  end
end
