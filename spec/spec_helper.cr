require "spec"
require "../src/crul"

struct FakeResponse
  getter :body, :headers

  def initialize(@body = "", content_type = nil)
    @headers = HTTP::Headers.new
    if content_type
      @headers["Content-Type"] = content_type
    end
  end
end
