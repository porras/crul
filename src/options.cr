require "option_parser"

module Crul
  class Options
    property :formatter, :method, :body, :headers, :basic_auth, :cookie_store, :errors
    property! :url, :parser
    property? :help, :version

    def initialize
      @formatter = Formatters::Auto
      @method = Methods::GET
      @headers = HTTP::Headers.new
      @cookie_store = CookieStore.new
      @errors = [] of Exception
    end

    def self.parse(args)
      new.tap do |options|
        options.parser = OptionParser.parse(args) do |parser|
          parser.banner = "Usage: crul [method] URL [options]"

          parser.separator
          parser.separator "HTTP methods (default: GET):"
          parser.on("get", "GET", "Use GET") { options.method = Methods::GET }
          parser.on("post", "POST", "Use POST") { options.method = Methods::POST }
          parser.on("put", "PUT", "Use PUT") { options.method = Methods::PUT }
          parser.on("delete", "DELETE", "Use DELETE") { options.method = Methods::DELETE }

          parser.separator
          parser.separator "HTTP options:"
          parser.on("-d DATA", "--data DATA", "Request body") do |body|
            options.body = if body.starts_with?('@')
                             begin
                               File.read(body[1..-1])
                             rescue e
                               options.errors << e
                               nil
                             end
                           else
                             body
                           end
          end
          parser.on("-d @file", "--data @file", "Request body (read from file)") { } # previous handler
          parser.on("-H HEADER", "--header HEADER", "Set header") do |header|
            name, value = header.split(':', 2)
            options.headers[name] = value
          end
          parser.on("-a USER:PASS", "--auth USER:PASS", "Basic auth") do |user_pass|
            pieces = user_pass.split(':', 2)
            options.basic_auth = {pieces[0], pieces[1]? || ""}
          end
          parser.on("-c FILE", "--cookies FILE", "Use FILE as cookie store (reads and writes)") do |file|
            options.cookie_store.load(file)
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
            options.help = true
          end
          parser.on("-V", "--version", "Display version") do
            options.version = true
          end

          parser.unknown_args do |args|
            if args.empty?
              options.errors << Exception.new("Please specify URL")
            else
              options.url = parse_uri(args.first)
            end
          end

          parser.separator
        end
      end
    end

    private def self.parse_uri(string)
      uri = URI.parse(string)
      uri = URI.parse("http://#{string}") if uri.host.nil?
      uri
    end
  end
end
