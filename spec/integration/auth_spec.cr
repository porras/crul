require "../spec_helper"

describe "Basic auth" do
  it "sends the basic auth data" do
    WebMock.stub(:get, "http://example.org/auth")
      .with(headers: {"Authorization" => "Basic #{Base64.strict_encode64("user:secret")}"})
      .to_return(body: "Hello, World")

    lines = capture_lines do |output|
      Crul::CLI.run!(["get", "http://example.org/auth", "-a", "user:secret"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello, World")
  end
end
