# taken almost verbatim from https://github.com/mosop/cli/blob/f3f706844a7bd467ab52772f4c3fdc07c055d7ec/src/lib/command_class.cr#L111-L135

module Crul
  module Completion
    def self.setup
      case ARGV.first?
      when "--completion"
        puts generate_bash_completion
        exit
      when "--zsh-completion"
        puts generate_zsh_completion(ARGV[1]? == "--functional")
        exit
      end
    end

    def self.generate_bash_completion
      g = Crul::Options::Parser.__klass.bash_completion.new_generator("_crul")
      <<-EOS
      #{g.result}
      complete -F #{g.entry_point} crul
      EOS
    end

    def self.generate_zsh_completion(functional)
      g = Crul::Options::Parser.__klass.zsh_completion.new_generator("_crul")
      if functional
        <<-EOS
        #compdef crul
        #{g.result}
        EOS
      else
        <<-EOS
        #{g.result}
        compdef #{g.entry_point} crul
        EOS
      end
    end
  end
end
