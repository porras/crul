require "./src/*"

Crul::Completion.setup

if Crul::CLI.run!(ARGV, STDOUT)
  exit
else
  exit -1
end
