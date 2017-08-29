require "../spec_helper"

describe Crul::Formatters::Auto do
  describe "#formatter" do
    it "detects JSON" do
      output = IO::Memory.new
      response = FakeResponse.new(content_type: "application/json")
      formatter = Crul::Formatters::Auto.new(output, response)

      formatter.formatter.should be_a(Crul::Formatters::JSON)
    end

    it "detects JSONAPI" do
      output = IO::Memory.new
      response = FakeResponse.new(content_type: "application/vnd.api+json")
      formatter = Crul::Formatters::Auto.new(output, response)

      formatter.formatter.should be_a(Crul::Formatters::JSON)
    end

    it "detects XML" do
      output = IO::Memory.new
      response = FakeResponse.new(content_type: "application/xml")
      formatter = Crul::Formatters::Auto.new(output, response)

      formatter.formatter.should be_a(Crul::Formatters::XML)
    end

    it "defaults to plain" do
      output = IO::Memory.new
      response = FakeResponse.new(content_type: "text/csv")
      formatter = Crul::Formatters::Auto.new(output, response)

      formatter.formatter.should be_a(Crul::Formatters::Plain)
    end

    it "works without a header" do
      output = IO::Memory.new
      response = FakeResponse.new
      formatter = Crul::Formatters::Auto.new(output, response)

      formatter.formatter.should be_a(Crul::Formatters::Plain)
    end

    it "works with an encoding" do
      output = IO::Memory.new
      response = FakeResponse.new(content_type: "application/xml; charset=ISO-8859-1")
      formatter = Crul::Formatters::Auto.new(output, response)

      formatter.formatter.should be_a(Crul::Formatters::XML)
    end
  end
end
