require "http/client"
require "colorize"

module Crul
  class Command
    def initialize(@output, @options)
    end

    def run!
      connect do |client|
        print_response client.exec(@options.method.to_s, @options.url.full_path, @options.headers, @options.body)
      end
    end

    private def connect
      HTTP::Client.new(@options.url.host.not_nil!, @options.url.port, @options.url.scheme == "https") do |client|
        if basic_auth = @options.basic_auth
          client.basic_auth(*basic_auth)
        end

        begin
          yield client
        ensure
          client.close
        end
      end
    rescue e : Errno | SocketError
      puts e.message
      exit -1
    end

    private def print_response(response)
      with_color.light_blue.surround { @output << response.version }
      with_color.cyan.surround { @output << " #{response.status_code} " }
      with_color.yellow.surround { @output.puts response.status_message }
      response.headers.each do |name, value|
        @output << "#{name}: "
        with_color.cyan.surround { @output.puts value }
      end
      @output.puts
      @options.formatter.new(@output, response).print
    end
  end
end
