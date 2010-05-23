require 'helper'

class FormstackTest < Test::Unit::TestCase
  
  context "Formstack API" do
    
    setup do
      @client = Formstack::Client.new("OU812")
    end
    
    should "list forms for an account" do
      stub_get("/forms?type=json&api_key=OU812", "forms.json")
      forms = @client.forms
      forms.size.should == 1
      forms.first.name.should == 'Contact'
    end
    
    should "get details for a form" do
      stub_get("/form?id=1234&type=json&api_key=OU812", "form.json")
      form = @client.form(1234)
      form.fields.size.should == 5
      form.fields.first.section_heading.should == 'Contact Information'
    end
    
    should "get submitted data for a form" do
      stub_get("/data?id=1234&page=1&type=json&api_key=OU812", "data.json")
      submissions = @client.data(1234, :page => 1).submissions
      submissions.size.should == 2
      submissions.first['1111'].should == "John Smith"
      submissions.first.timestamp.year.should == 2007
    end
    
    should "return a single submission collected for a form" do
      stub_get("/submission?id=1001&type=json&api_key=OU812", "submission.json")
      submission = @client.submission(1001)
      submission['2222'].should == "Apple"
      submission.timestamp.year.should == 2007
    end
    
    should "prepare data for form submission" do
      stub_get("/form?id=1234&type=json&api_key=OU812", "form.json")
      params = {:page => 3, :data => {:name => "Wynn Netherland", :phone => "940-867-5309", '123' => 'foo'}}
      prepared = @client.prepare_params(1234, params)
      prepared['field_7344054'].should == 'Wynn Netherland'
      prepared['field_7344057'].should == '940-867-5309'
      prepared['field_123'].should == 'foo'
    end
    
    should "submit data for a form" do
      stub_post("/submit?type=json&api_key=OU812", "submit.json")
      id = @client.submit(1234, :data => {:foo => 'bar'})
      id.should == 10001
    end
    
    should "update submitted data for a form" do
      stub_post("/edit?type=json&api_key=OU812", "submit.json")
      id = @client.edit(1234, :data => {:foo => 'bar'})
      id.should == 10001
    end
    
    should "delete submitted data for a form" do
      stub_post("/delete?type=json&api_key=OU812", "submit.json")
      id = @client.delete(1234)
      id.should == 10001
    end

  end

end
