require "optarg"
require "uri"

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

    class Parser < Optarg::Model
      arg "method", complete: %w(get put post delete GET PUT POST DELETE)
      arg "url", complete: %w(http:// https://)

      string %w(-d --data)
      array %w(-H --header)
      string %w(-a --auth)
      string %w(-c --cookies)

      bool %w(-j --json)
      bool %w(-x --xml)
      bool %w(-p --plain)

      bool %w(-h --help), stop: true
      bool %w(-V --version), stop: true
    end

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
        parsed = Parser.parse(args)

        method, url = parsed.method?, parsed.url?
        # if only one is present, it's treated as a URL
        if method && !url
          method, url = url, method
        end

        options.method = case method
                         when "post", "POST"
                           Methods::POST
                         when "put", "PUT"
                           Methods::PUT
                         when "delete", "DELETE"
                           Methods::DELETE
                         else # GET is the default
                           Methods::GET
                         end

        if url
          options.url = parse_uri(url)
        else
          options.errors << Exception.new("Please specify URL")
        end

        if parsed.data?
          options.body = if parsed.data.starts_with?('@')
                           begin
                             File.read(parsed.data[1..-1])
                           rescue e
                             options.errors << e
                             nil
                           end
                         else
                           parsed.data
                         end
        end

        parsed.header.each do |h|
          name, value = h.split(':', 2)
          options.headers[name] = value
        end

        if parsed.auth?
          pieces = parsed.auth.split(':', 2)
          options.basic_auth = {pieces[0], pieces[1]? || ""}
        end

        options.cookie_store.load(parsed.cookies) if parsed.cookies?

        options.format = Format::JSON if parsed.json?
        options.format = Format::XML if parsed.xml?
        options.format = Format::Plain if parsed.plain?

        options.help = parsed.help?
        options.version = parsed.version?
      end
    end

    private def self.parse_uri(string)
      uri = URI.parse(string)
      uri = URI.parse("http://#{string}") if uri.host.nil?
      uri
    end
  end
end
