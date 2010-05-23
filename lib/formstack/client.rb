module Formstack
  class Client
    include HTTParty
    base_uri "https://www.formstack.com/api/"
    format :json

    def initialize(key)
      self.class.default_params(:api_key => key, :type => 'json')
    end
    
    def forms
      self.class.get("/forms").forms.map{|f| handle_form(f)}
    end
    
    def form(form_id)
      handle_form(self.class.get("/form", :query => {:id => form_id}))
    end
    
    def data(form_id, options={})
      api_response = self.class.get("/data", :query => {:id => form_id}.merge(options))
      api_response.submissions = api_response.submissions.map{|s| handle_submission(s) }
      api_response
    end
    alias :submissions :data
    
    def submission(submission_id, options={})
      handle_submission(self.class.get("/submission", :query => {:id => submission_id}.merge(options)))
    end

    
    def submit(form_id, options={})
      self.class.post("/submit", :body => {:id => form_id}.merge(prepare_params(form_id, options)))['id']
    end
    
    def edit(submission_id, options={})
      self.class.post("/edit", :body => {:id => submission_id}.merge(prepare_params(submission_id, options)))['id']
    end
    
    def delete(submission_id)
      self.class.post("/delete", :body => {:id => submission_id})['id']
    end
    
    
    def prepare_params(form_id, params={})
      data = params.delete(:data)
      form = form(form_id)
      data.each do |field, value|
        field_id = form.fields.any? {|f| f['name'] == field.to_s} ? form.fields.find {|f| f['name'] == field.to_s}['id'] : field
        params["field_#{field_id}"] = value
      end
      params
    end
    
    def handle_form(form)
      form.created = Time.parse(form.created) unless form.created.nil?
      form
    end
    
    def handle_submission(submission)
      data = submission.data      
      data.each do |datum|
        submission[datum.field] = datum.value
      end
      submission.timestamp = Time.parse(submission.timestamp)
      submission
    end

    def self.get(*args); handle_response super end
    def self.post(*args); handle_response super end
    
    def self.handle_response(response)
      case response.code
      when 500...600; raise FormstackError.new(Hashie::Mash.new(response).error)
      else; response
      end
      
      Hashie::Mash.new(response).response
      
    end
    
  end
end