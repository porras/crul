module Crul
  module CLI
    def self.run!(argv, output)
      options = Options.parse(argv)

      if options.help?
        output.puts options.parser
        return true
      end

      if options.version?
        output.puts Crul.version_string
        return true
      end

      if options.errors.any?
        output.puts options.parser

        output.puts "Errors:"
        options.errors.each do |error|
          output.puts "  * " + error.to_s
        end
        output.puts
        return false
      end

      Command.new(output, options).run!
      true
    end
  end
end
