require "../spec_helper"

describe Crul::Formatters::JSON do
  describe "#print" do
    context "with valid JSON" do
      it "formats it" do
        output = IO::Memory.new
        response = FakeResponse.new("{\"a\":1}")
        formatter = Crul::Formatters::JSON.new(output, response)

        formatter.print

        Hash(String, Int32).from_json(uncolorize(output.to_s)).should eq({"a" => 1})
      end
    end

    context "with invalid JSON" do
      it "formats it (falling back to plain)" do
        output = IO::Memory.new
        response = FakeResponse.new("{{{")
        formatter = Crul::Formatters::JSON.new(output, response)

        formatter.print

        output.to_s.strip.should eq("{{{")
      end
    end
  end
end
