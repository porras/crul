require "./spec_helper"

describe Crul::Options do
  describe ".parse" do
    it "GET with JSON" do
      options = Crul::Options.parse("GET http://example.org -j".split(" "))

      options.method.should eq(Crul::Methods::GET)
      options.url.should be_a(URI)
      options.url.to_s.should eq("http://example.org")
      options.formatter.should eq(Crul::Formatters::JSON)
    end

    it "POST with JSON" do
      options = Crul::Options.parse("POST http://example.org -j".split(" "))

      options.method.should eq(Crul::Methods::POST)
      options.url.should be_a(URI)
      options.url.to_s.should eq("http://example.org")
      options.formatter.should eq(Crul::Formatters::JSON)
    end

    it "defaults to auto formatter" do
      options = Crul::Options.parse("GET http://example.org".split(" "))

      options.method.should eq(Crul::Methods::GET)
      options.url.should be_a(URI)
      options.url.to_s.should eq("http://example.org")
      options.formatter.should eq(Crul::Formatters::Auto)
    end

    it "defaults to GET" do
      options = Crul::Options.parse("-j http://example.org".split(" "))

      options.method.should eq(Crul::Methods::GET)
      options.url.should be_a(URI)
      options.url.to_s.should eq("http://example.org")
      options.formatter.should eq(Crul::Formatters::JSON)
    end

    it "GET with XML" do
      options = Crul::Options.parse("GET http://example.org -x".split(" "))

      options.method.should eq(Crul::Methods::GET)
      options.url.should be_a(URI)
      options.url.to_s.should eq("http://example.org")
      options.formatter.should eq(Crul::Formatters::XML)
    end

    it "GET with plain" do
      options = Crul::Options.parse("GET http://example.org -p".split(" "))

      options.method.should eq(Crul::Methods::GET)
      options.url.should be_a(URI)
      options.url.to_s.should eq("http://example.org")
      options.formatter.should eq(Crul::Formatters::Plain)
    end

    it "most basic" do
      options = Crul::Options.parse("http://example.org".split(" "))

      options.method.should eq(Crul::Methods::GET)
      options.url.should be_a(URI)
      options.url.to_s.should eq("http://example.org")
      options.formatter.should eq(Crul::Formatters::Auto)
    end

    it "accepts a request body" do
      options = Crul::Options.parse("http://example.org -d data".split(" "))

      options.body.should eq("data")
    end

    it "accepts headers" do
      options = Crul::Options.parse("http://example.org -H header1:value1 -H header2:value2".split(" "))

      options.headers["Header1"].should eq("value1")
      options.headers["Header2"].should eq("value2")
    end

    it "accepts headers with JSON values" do
      header_value = {"a" => "b"}
      options = Crul::Options.parse("http://example.org -H JSON:#{header_value.to_json}".split(" "))

      JSON.parse(options.headers["json"]).should eq(header_value)
    end

    it "gets user and password with --auth" do
      options = Crul::Options.parse("GET http://example.org --auth foo:bar".split(" "))
      options.basic_auth.should eq({"foo", "bar"})
    end

    it "gets user and password with -a" do
      options = Crul::Options.parse("GET http://example.org -a foo:bar".split(" "))
      options.basic_auth.should eq({"foo", "bar"})
    end
  end
end
