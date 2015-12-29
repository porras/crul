require "../spec_helper"

describe "Cookies" do
  it "stores and sends the cookies" do
    WebMock.stub(:get, "example.org/cookies/set")
           .to_return(headers: {"Set-Cookie" => "k1=v1; Path=/"}, body: "Cookie set")

    WebMock.stub(:get, "example.org/cookies/check")
           .with(headers: {"Cookie" => "k1=v1; Path=/"})
           .to_return(body: "Cookie received")

    lines = capture_lines do |output|
      Crul::CLI.run!(["get", "http://example.org/cookies/set", "-c", "/tmp/cookies"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Cookie set")

    lines = capture_lines do |output|
      Crul::CLI.run!(["get", "http://example.org/cookies/check", "-c", "/tmp/cookies"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Cookie received")
  end
end
