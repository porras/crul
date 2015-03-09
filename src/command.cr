require "http/client"

module Crul
  class Command
    def initialize(@options)
    end

    def run!
      connect do |client|
        print_response client.exec(@options.method, @options.url.path || "/")
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
      puts "#{response.version} #{response.status_code} #{response.status_message}"
      response.headers.each do |name, value|
        puts "#{name}: #{value}"
      end
      puts
      formatter.print(response.body)
    end

    private def formatter
      if @options.formatter
        @options.formatter.not_nil!.new
      else
        Formatters::Plain.new
      end
    end
  end
end
