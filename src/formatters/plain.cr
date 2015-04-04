module Crul
  module Formatters
    class Plain < Base
      def print
        @output.puts @response.body
      end
    end
  end
end
