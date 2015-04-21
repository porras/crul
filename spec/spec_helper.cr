require "spec"
require "../src/*"
require "webmock"

struct FakeResponse
  getter :body, :headers

  def initialize(@body = "", content_type = nil)
    @headers = HTTP::Headers.new
    if content_type
      @headers["Content-Type"] = content_type
    end
  end
end

def capture_lines(&block)
  output = StringIO.new
  yield(output)
  output.to_s.split("\n")
end
