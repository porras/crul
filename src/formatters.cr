module Crul
  module Formatters
    abstract class Base
      def initialize(@output, @response)
      end

      def print_plain
        Plain.new(@output, @response).print
      end
    end
  end
end

require "./formatters/*"
