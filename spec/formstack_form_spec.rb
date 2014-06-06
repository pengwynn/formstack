require 'spec_helper'

describe FormStack::Form do

  before(:each) do
    @client = FormStack::Connection.new(
      :access_token => "OU812"
    )
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

  describe "get_id_of_field_name_from" do
    before(:each) do
      @form = @client.forms.find(1)
    end

    it "should return the field id if the field exists" do
      result = @form.get_id_of_field_name("Name", "text")
      result.should == "12345"
    end

    it "should create a new field if the field doesn't exist" do
      @forms.stub(:fields).and_return([])
      result = @form.get_id_of_field_name("test", "text")
      result.should == "12345"
    end

    it "should not create a new field if the field doesn't exist" do
      @forms.stub(:fields).and_return([])
      result = @form.get_id_of_field_name("test")
      result.should == nil
    end
  end

  describe "values_for_submission_id" do
    before(:each) do
      @form = @client.forms.find(1)
    end

    it "returns a non-empty hash" do
      result = @form.values_for_submission_id(1001)
      result["whats_on_your_mind"].should == "nothin" # from fixtures
    end

    it "returns default hash for bad submission id" do
      FormStack::Submission.stub(:find).and_return(nil)
      result = @form.values_for_submission_id(9999999)

      result.should_not be_empty
      @form.data_fields.each do | field |
        result[field["name"]].should == field["default"]
      end
    end


  end
end
