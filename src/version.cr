module Crul
  VERSION = "0.4.2"

  def self.version_string
    "crul #{VERSION} (#{{{`date -u`.strip.stringify}}})"
  end
end
