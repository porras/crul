require "completion"

module Crul
  module Completion
    macro setup
      completion :options do |comp|
        comp.on :options do
          comp.reply [
            "get", "post", "put", "delete",
            "--help",
            "--data", "--header", "--auth", "--cookies",
            "--json", "--xml", "--plain",
          ]
        end
      end
    end
  end
end
