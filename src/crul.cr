require "./socket_fix"
require "./options"
require "./command"

module Crul
  module CLI
    def self.run!
      Command.new(STDOUT, Options.parse(ARGV)).run!
    end
  end
end

