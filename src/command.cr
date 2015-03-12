require "http/client"

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
        begin
          yield client
        ensure
          client.close
        end
      end
    end

    private def print_response(response)
      @output.puts "#{response.version} #{response.status_code} #{response.status_message}"
      response.headers.each do |name, value|
        @output.puts "#{name}: #{value}"
      end
      @output.puts
      @options.formatter.new(@output).print(response.body)
    end
  end
end
