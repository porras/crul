require "http/client"
require "colorize"

module Crul
  class Command
    @host : String
    @port : Int32

    def initialize(@output : IO, @options : Options)
      @host = @options.url.host.not_nil!
      @port = @options.url.port || default_port
    end

    def run!
      connect do |client|
        @options.cookie_store.add_to_headers(@host, @port, @options.headers)

        response = client.exec(@options.method.to_s, @options.url.full_path, @options.headers, @options.body)

        print_response response

        @options.cookie_store.store_cookies(@host, @port, response.headers)
        @options.cookie_store.write!
      end
    end

    private def connect
      HTTP::Client.new(@host, @port, @options.url.scheme == "https") do |client|
        if basic_auth = @options.basic_auth
          client.basic_auth(*basic_auth)
        end

        begin
          yield client
        ensure
          client.close
        end
      end
    rescue e : Errno | Socket::Error
      puts e.message
      exit -1
    end

    private def print_response(response)
      with_color.light_blue.surround(@output) { |io| io << response.version }
      with_color.cyan.surround(@output) { |io| io << " #{response.status_code} " }
      with_color.yellow.surround(@output) { |io| io.puts response.status_message }
      response.headers.each do |name, values|
        values.each do |value|
          @output << "#{name}: "
          with_color.cyan.surround(@output) { |io| io.puts value }
        end
      end
      @output.puts
      Formatters.new(@options.format, @output, response).print
    end

    private def default_port
      @options.url.scheme == "https" ? 443 : 80
    end
  end
end
