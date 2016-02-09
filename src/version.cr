module Crul
  VERSION = "0.4.0"

  def self.version_string
    "crul #{VERSION} (#{{{`date -u`.strip.stringify}}})"
  end
end
