module Crul
  VERSION = "0.3.1"

  def self.version_string
    "crul #{VERSION} (#{{{`date -u`.strip.stringify}}})"
  end
end
