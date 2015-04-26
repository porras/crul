require "../spec_helper"

describe "Sending headers" do
  webmock_it "sends the headers" do
    WebMock.stub(:get, "http://example.org/headers")
      .with(headers: { "Hello" => "World", "Header" => "Value"})
      .to_return(body: "Hello, World")

    lines = capture_lines do |output|
      Crul::CLI.run!(["get", "http://example.org/headers", "-H", "Hello:World", "-H", "Header:Value"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello, World")
  end
end
