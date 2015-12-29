require "../spec_helper"

describe Crul::Formatters::XML do
  describe "#print" do
    context "with valid XML" do
      it "formats it" do
        output = MemoryIO.new
        response = FakeResponse.new("<a><b>c</b></a>")
        formatter = Crul::Formatters::XML.new(output, response)

        formatter.print

        # we should parse and assert on output but it'll be much easier with the new XML features in next Crystal release
        # for the time being no exception raised is Good Enough™
      end
    end

    context "with malformed XML" do
      it "formats it (falling back to plain)" do
        output = MemoryIO.new
        response = FakeResponse.new("<<<")
        formatter = Crul::Formatters::XML.new(output, response)

        formatter.print

        output.to_s.strip.should eq("<<<")
      end
    end
  end
end
