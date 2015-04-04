require "./socket_fix"
require "./xml_fix"
require "./options"
require "./command"

module Crul
  module CLI
    def self.run!
      options = Options.parse(ARGV)

      if options.help?
        puts options.parser
        exit
      end

      if options.errors.any?
        puts options.parser

        puts "Errors:"
        options.errors.each do |error|
          puts "  * " + error.to_s
        end
        puts
        exit -1
      end

      Command.new(STDOUT, options).run!
    end
  end
end

