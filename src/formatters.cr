module Crul
  enum Format
    Auto
    XML
    JSON
    Plain
  end

  module Formatters
    MAP = {
      Format::Auto  => Formatters::Auto,
      Format::XML   => Formatters::XML,
      Format::JSON  => Formatters::JSON,
      Format::Plain => Formatters::Plain,
    }

    def self.new(format, *args)
      MAP[format].new(*args)
    end

    abstract class Base
      def initialize(@output : IO, @response : HTTP::Client::Response)
      end

      def print_plain
        Plain.new(@output, @response).print
      end
    end
  end
end

require "./formatters/*"
