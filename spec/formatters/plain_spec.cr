require "../spec_helper"

describe Crul::Formatters::Plain do
  describe "#print" do
    it "prints" do
      output = StringIO.new
      formatter = Crul::Formatters::Plain.new(output)

      formatter.print("Hello")

      output.to_s.strip.should eq("Hello")
    end
  end
end
