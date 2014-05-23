module FormStack
  class Form < HashAttributeClass

    def initialize(attrs = {})
      super
      defaults = {
        :id => "",
        :name => "",
        :views => "",
        :created => "",
        :submissions => "",
        :submissions_unread => 0,
        :submissions_today => 0,
        :last_submission_id => "",
        :last_submission_time => "",
        :url => "",
        :data_url => "",
        :summary_url => "",
        :rss_url => "",
        :encrypted => false,
        :thumnail_url => "",
        :submit_button_title => "",
        :inactive => false,
        :timezone => "",
        :folder => "none",
        :javascript => "",
        :html => "",
        :fields => []
      }
      @attributes = defaults.merge(attrs)
    end

    # https://www.formstack.com/developers/api/resources/form#form_GET
    def self.all
      forms = []
      result = self.connection.get(
        :url => CONTROLLER
      )
      result["forms"].each {|f|
        forms << FormStack::Form.new(f)
      }
      return forms
    end

    # https://www.formstack.com/developers/api/resources/form#form_POST
    def self.create(attrs = {})
      result = self.connection.post(
        :url => CONTROLLER,
        :params => self.define_attributes.merge(attrs)
      )
    end

    # https://www.formstack.com/developers/api/resources/form#form/:id/copy_POST
    def self.copy(id)
      result = self.connection.post(
        :url => "#{CONTROLLER}/#{id}"
      )
      f = FormStack::Form.new
      f.attributes = result
      return f
    end

    # fields

    # https://www.formstack.com/developers/api/resources/field#form/:id/field_GET
    def fields
      fields = []
      result = self.class.connection.get(
        :url => "#{CONTROLLER}/#{self[:id]}/field"
      )
      (result.is_a?(Array) ? result : result["fields"]).each {|f|
        fields << FormStack::Field.new(f)
      } if !result.empty?
      return fields
    end

    # https://www.formstack.com/developers/api/resources/field#form/:id/field_POST
    def create_field(attrs = {})
      result = self.class.connection.post(
        :url => "#{CONTROLLER}/#{self[:id]}/field",
        :params => attrs
      )
      return result
    end

    # submissions

    # https://www.formstack.com/developers/api/resources/submission#form/:id/submission_GET
    def submissions(attrs = {})
      submissions = []
      result = self.class.connection.get(
        :url => "#{CONTROLLER}/#{self[:id]}/submission",
        :params => attrs
      )
      result["submissions"].each {|s|
        submissions << FormStack::Submission.new(s)
      }
      return submissions
    end

    # https://www.formstack.com/developers/api/resources/submission#form/:id/submission_POST
    def create_submission(attrs = {})
      result = self.class.connection.post(
        :url => "#{CONTROLLER}/#{self[:id]}/submission",
        :params => attrs
      )
      return result
    end

    # confirmations

    # https://www.formstack.com/developers/api/resources/confirmation#form/:id/confirmation_GET
    def confirmations
      confirmations = []
      result = self.class.connection.get(
        :url => "#{CONTROLLER}/#{self[:id]}/confirmation"
      )
      result["confirmations"].each {|s|
        confirmations << FormStack::Confirmation.new(s)
      }
      return confirmations
    end

    # https://www.formstack.com/developers/api/resources/confirmation#form/:id/confirmation_POST
    def create_confirmation(attrs = {})
      result = self.class.connection.post(
        :url => "#{CONTROLLER}/#{self[:id]}/confirmation",
        :params => attrs
      )
      return result
    end

    # webhooks

    # https://www.formstack.com/developers/api/resources/webhook#form/:id/webhook_GET
    def webhooks
      webhooks = []
      result = self.class.connection.get(
        :url => "#{CONTROLLER}/#{self[:id]}/webhook"
      )
      result["webhooks"].each {|s|
        webhooks << FormStack::Webhook.new(s)
      }
      return webhooks
    end


    # https://www.formstack.com/developers/api/resources/webhook#form/:id/webhook_POST
    def create_webhook(attrs = {})
      result = self.class.connection.post(
        :url => "#{CONTROLLER}/#{self[:id]}/webhook",
        :params => attrs
      )
      return result
    end

    #######################
    # non basic api methods
    # #####################

    # for a given field name,
    # retrieve the id of that field
    def get_id_of_field_name(name, kind = "")
      @fields ||= self.fields
      field = @fields.select{|f| f["name"] == name}

      if field.empty?
        create_if_missing = kind.present?

        if  create_if_missing
          # create the proposal_id field, and make sure it's hidden
          field = self.create_field(
            :field_type => kind,
            :label => name,
            :hidden => 1,
            :hide_label => 1
          )
          return field["id"]
        end
        return nil
      else
        return field[0]["id"]
      end
    end

    # for a given submission_id,
    # generate a hash of field name to value
    def values_for_submission_id(submission_id, include_hidden = false)
      result = {}

      # cache submission
      submission = instance_variable_get("@submission_#{submission_id}")
      submission ||= self.class.connection.submissions.find(submission_id)
			instance_variable_set("@submission_#{submission_id}", submission)

      fields = self.fields

      fields.each do |field|
        next if (!include_hidden and (field["hidden"] == "1" or field["type"] == "section"))

        name = field["name"]
        default = field["default"]
        value = ((submission ? submission.value_of(field["id"]) : default) || default)
        result[name] = value
      end

      result
    end

  end
end
