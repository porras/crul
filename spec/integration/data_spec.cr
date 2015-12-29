require "../spec_helper"

describe "Sending data" do
  it "sends the data" do
    WebMock.stub(:post, "http://example.org/data")
           .with(body: "Hello")
           .to_return(body: "World")

    lines = capture_lines do |output|
      Crul::CLI.run!(["post", "http://example.org/data", "-d", "Hello"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("World")
  end

  it "sends the data from a file" do
    WebMock.stub(:post, "http://example.org/data")
           .with(body: File.read(__FILE__))
           .to_return(body: "World")

    lines = capture_lines do |output|
      Crul::CLI.run!(["post", "http://example.org/data", "-d", "@#{__FILE__}"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("World")
  end
end
