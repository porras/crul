require "../spec_helper"

describe Crul::Formatters::Plain do
  describe "#print" do
    it "prints" do
      output = IO::Memory.new
      response = FakeResponse.new("Hello")
      formatter = Crul::Formatters::Plain.new(output, response)

      formatter.print

      output.to_s.strip.should eq("Hello")
    end
  end
end
