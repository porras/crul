module Crul
  module Formatters
    abstract class Base
      def initialize(@output)
      end

      def print_plain(body)
        Plain.new(@output).print(body)
      end
    end
  end
end

require "./formatters/*"
