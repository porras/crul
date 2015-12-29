require "completion"

completion :options do |comp|
  comp.reply :options, [
    "get", "post", "put", "delete",
    "--help",
    "--data", "--header", "--auth", "--cookies",
    "--json", "--xml", "--plain",
  ]
end

if ARGV.first? && ARGV.first =~ /^--comp/
  exit 0
end
