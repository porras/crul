require "option_parser"

module Crul
  class Options
    property :format, :method, :body, :headers, :basic_auth, :cookie_store, :errors
    property! :url, :parser
    property? :help, :version

    @body : String?
    @basic_auth : Tuple(String, String)?
    @help : Bool?
    @version : Bool?
    @url : URI?

    @parser : OptionParser?

    def initialize
      @format = Format::Auto
      @method = Methods::GET
      @headers = HTTP::Headers.new
      @cookie_store = CookieStore.new
      @errors = [] of Exception
    end

    USAGE = <<-USAGE
      Usage: crul [method] URL [options]

      HTTP methods (default: GET):
        get, GET                         Use GET
        post, POST                       Use POST
        put, PUT                         Use PUT
        delete, DELETE                   Use DELETE

      HTTP options:
        -d DATA, --data DATA             Request body
        -d @file, --data @file           Request body (read from file)
        -H HEADER, --header HEADER       Set header
        -a USER:PASS, --auth USER:PASS   Basic auth
        -c FILE, --cookies FILE          Use FILE as cookie store (reads and writes)

      Response formats (default: autodetect):
        -j, --json                       Format response as JSON
        -x, --xml                        Format response as XML
        -p, --plain                      Format response as plain text

      Other options:
        -h, --help                       Show this help
        -V, --version                    Display version
    USAGE

    def self.parse(args)
      new.tap do |options|
        case args.first?
        when "get", "GET"
          args.shift
          options.method = Methods::GET
        when "post", "POST"
          args.shift
          options.method = Methods::POST
        when "put", "PUT"
          args.shift
          options.method = Methods::PUT
        when "delete", "DELETE"
          args.shift
          options.method = Methods::DELETE
        else # it's the default
          options.method = Methods::GET
        end

        options.parser = OptionParser.parse(args) do |parser|
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
            options.format = Format::JSON
          end
          parser.on("-x", "--xml", "Format response as XML") do |method|
            options.format = Format::XML
          end
          parser.on("-p", "--plain", "Format response as plain text") do |method|
            options.format = Format::Plain
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
