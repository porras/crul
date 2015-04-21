require "../spec_helper"

describe "Basic examples" do
  it "no args" do
    lines = capture_lines do |output|
      Crul::CLI.run!([] of String, output).should be_false
    end

    lines.first.should match(/\AUsage:/)
    lines[-2].should match(/Please specify URL/)
  end

  it "most basic GET" do
    WebMock.stub(:get, "http://example.org/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["http://example.org"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello")
  end

  it "most basic GET with https" do
    WebMock.stub(:get, "https://example.org/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["https://example.org"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello")
  end

  it "most basic GET with port" do
    WebMock.stub(:get, "http://example.org:8080/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["http://example.org:8080/"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello")
  end
end
