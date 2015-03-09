require "./spec_helper"

describe Crul::Options do
  describe ".parse" do
    it "GET with JSON" do
      options = Crul::Options.parse("-X GET http://example.org -j".split(" "))

      options.method.should eq("GET")
      options.url.should be_a(URI)
      options.url.to_s.should eq("http://example.org")
      options.formatter.should eq(Crul::Formatters::JSON)
    end

    it "POST with JSON" do
      options = Crul::Options.parse("-X POST http://example.org -j".split(" "))

      options.method.should eq("POST")
      options.url.should be_a(URI)
      options.url.to_s.should eq("http://example.org")
      options.formatter.should eq(Crul::Formatters::JSON)
    end

    it "defaults to no formatter" do
      options = Crul::Options.parse("-X GET http://example.org".split(" "))

      options.method.should eq("GET")
      options.url.should be_a(URI)
      options.url.to_s.should eq("http://example.org")
      options.formatter.should be_nil
    end

    it "defaults to GET" do
      options = Crul::Options.parse("-j http://example.org".split(" "))

      options.method.should eq("GET")
      options.url.should be_a(URI)
      options.url.to_s.should eq("http://example.org")
      options.formatter.should eq(Crul::Formatters::JSON)
    end

    it "most basic" do
      options = Crul::Options.parse("http://example.org".split(" "))

      options.method.should eq("GET")
      options.url.should be_a(URI)
      options.url.to_s.should eq("http://example.org")
      options.formatter.should be_nil
    end
  end
end
