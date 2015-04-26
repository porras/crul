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

# temporary workaround to spec's lack of before hooks (they'll be in the next crystal release)
def webmock_it(description, &block)
  it description do
    WebMock.wrap(&block)
  end
end

def uncolorize(string)
  String.build do |output|
    ignore = false
    string.chars.each do |char|
      if ignore
        if char == 'm'
          ignore = false
        end
      else
        if char == '\e'
          ignore = true
        else
          output << char
        end
      end
    end
  end
end
