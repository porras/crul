require "option_parser"

# backported from https://github.com/manastech/crystal/commit/0162e23b52b9b3353ccd7a085618396fc4c38ca2
class OptionParser
  def separator(message = "")
    @flags << message.to_s
  end
end
