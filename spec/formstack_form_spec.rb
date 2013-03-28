require 'spec_helper'

describe FormStack::Form do
    
  before(:each) do
    @client = FormStack::Connection.new({
      :access_token => "OU812"
      })
  end
  
  it "should list forms for an account" do
    stub_get("/forms?type=json&api_key=OU812", "forms.json")
    forms = @client.forms.all
    forms.size.should == 1
    forms.first[:name].should == 'Contact'
  end
  
  it "should get details for a form" do
    stub_get("/form?id=1234&type=json&api_key=OU812", "form.json")
    form = @client.forms.find(1234)
    form.fields.size.should == 5
    first = form.fields.first
    first.should be_kind_of(FormStack::Field)

    first["section_heading"].should == 'Contact Information'
  end
  
  it "should get submitted data for a form" do
    submissions = @client.forms.find(1234).submissions
    submissions.size.should == 1
    first = submissions.first
    first.should be_kind_of(FormStack::Submission)

    data = first["data"]
    data.first["field"].should == '1111'
    first["timestamp"].should include("2007")
  end
  
  it "should return a single submission collected for a form" do
    submission = @client.submissions.find(1001)
    submission["data"][1]["field"].should == '2222'
    submission["timestamp"].should include("2007")
  end
  
  it "should delete submitted data for a form" do
    response = @client.forms.find(1234).destroy()
    response["id"].should == "1"
  end
end
