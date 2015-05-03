require "../spec_helper"

describe "Basic examples" do
  it "no args" do
    lines = capture_lines do |output|
      Crul::CLI.run!([] of String, output).should be_false
    end

    lines.first.should match(/\AUsage:/)
    lines[-2].should match(/Please specify URL/)
  end

  it "help" do
    lines = capture_lines do |output|
      Crul::CLI.run!(["-h"], output).should be_true
    end

    lines.first.should match(/\AUsage:/)
  end

  it "most basic GET" do
    WebMock.stub(:get, "http://example.org/").to_return(body: "Hello", headers: { "Hello" => "World" })

    lines = capture_lines do |output|
      Crul::CLI.run!(["http://example.org"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines[2].should eq("Hello: World")
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

  it "most basic GET without protocol (should default to http://)" do
    WebMock.stub(:get, "http://example.org/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["example.org"], output).should be_true
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

  it "basic POST" do
    WebMock.stub(:post, "http://example.org/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["post", "http://example.org"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello")
  end

  it "basic PUT" do
    WebMock.stub(:put, "http://example.org/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["put", "http://example.org"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello")
  end

  it "basic DELETE" do
    WebMock.stub(:delete, "http://example.org/").to_return(body: "Hello")

    lines = capture_lines do |output|
      Crul::CLI.run!(["delete", "http://example.org"], output).should be_true
    end

    lines.first.should eq("HTTP/1.1 200 OK")
    lines.last.should eq("Hello")
  end
end
