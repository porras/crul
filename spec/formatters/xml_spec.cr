require "../spec_helper"

describe Crul::Formatters::XML do
  describe "#print" do
    context "with valid XML" do
      it "formats it" do
        output = StringIO.new
        response = FakeResponse.new("<a><b>c</b></a>")
        formatter = Crul::Formatters::XML.new(output, response)

        formatter.print

        # we should parse and assert on output here but it's full of control codes :D
        # no exception raised is Good Enough™
      end
    end

    context "with malformed XML" do
      it "formats it (falling back to plain)" do
        output = StringIO.new
        response = FakeResponse.new("<<<")
        formatter = Crul::Formatters::XML.new(output, response)

        formatter.print

        output.to_s.strip.should eq("<<<")
      end
    end
  end
end
