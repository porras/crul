require "./spec_helper"

# can be removed along with the fix itslef when new version of Crystal is released
describe "fixed XML" do
  it "handles errors" do
    expect_raises(XML::Error, "StartTag: invalid element name at line 2") do
      XML.parse(%(
        </people>
        ))
    end
  end
end
