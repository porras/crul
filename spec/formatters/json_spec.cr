require "../spec_helper"

describe Crul::Formatters::JSON do
  describe "#print" do
    context "with valid JSON" do
      it "formats it" do
        output = StringIO.new
        response = FakeResponse.new("{\"a\":1}")
        formatter = Crul::Formatters::JSON.new(output, response)

        formatter.print

        JSON.parse(uncolorize(output.to_s)).should eq({"a": 1})
      end
    end

    context "with invalid JSON" do
      it "formats it (falling back to plain)" do
        output = StringIO.new
        response = FakeResponse.new("{{{")
        formatter = Crul::Formatters::JSON.new(output, response)

        formatter.print

        output.to_s.strip.should eq("{{{")
      end
    end
  end
end
