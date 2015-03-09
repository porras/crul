require "./options"
require "./command"
require "./formatters/*"

module Crul
  module CLI
    def self.run!
      Command.new(Options.parse(ARGV)).run!
    end
  end
end

