require "../formatters"

module Crul
  module Formatters
    class Plain < Base
      def print(body)
        @output.puts body
      end
    end
  end
end
