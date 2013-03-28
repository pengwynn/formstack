require "spec_helper"

describe HashAttributeClass do

	it "should be a parent of the form class" do
		FormStack::Form.new.is_a?(HashAttributeClass).should == true
		# for the rest of these tests, we'll use the form class
	end

	it "should have indifferent access" do
		f = FormStack::Form.new({
			:one => 1,
			:two => 2
		})
		f["one"].should == f[:one]
		f["two"].should == f[:two]
	end

	it "should store hash keys as symbols" do
		f = FormStack::Form.new({
			"string_key" => 0,
			:symbol_key => 1
		})
		f.attributes.keys.should include(:string_key)
		f.attributes.keys.should include(:symbol_key)
	end

end