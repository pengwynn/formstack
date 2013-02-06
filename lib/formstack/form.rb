module FormStack
	class Form < HashAttributeClass

		# https://www.formstack.com/developers/api/resources/form#form_GET
		def self.all
			forms = []
			result = self.connection.get({
				:url => CONTROLLER
			})
			result["forms"].each {|f|
				forms << FormStack::Form.new(f)
			}
			return forms
		end	

		# https://www.formstack.com/developers/api/resources/form#form_POST
		def self.create(attrs = {})
			result = self.connection.post({
				:url => CONTROLLER,
				:params => self.define_attributes.merge(attrs)
			})
		end

		# https://www.formstack.com/developers/api/resources/form#form/:id/copy_POST
		def self.copy(id)
			result = self.connection.post({
				:url => "#{CONTROLLER}/#{id}"
			})
			f = FormStack::Form.new
			f.attributes = result
			return f
		end

		# fields

		# https://www.formstack.com/developers/api/resources/field#form/:id/field_GET
		def fields
			fields = []
			result = self.class.connection.get({
				:url => "#{CONTROLLER}/#{self[:id]}/field"
			})
			result.each {|f|
				fields << ((FormStack::Field.new).attributes = f)
			}
			return fields
		end

		# https://www.formstack.com/developers/api/resources/field#form/:id/field_POST
		def create_field(attrs = {})
			result = self.class.connection.post({
				:url => "#{CONTROLLER}/#{self[:id]}/field",
				:params => attrs
			})
			return result
		end

		# submissions

		# https://www.formstack.com/developers/api/resources/submission#form/:id/submission_GET
		def submissions
			submissions = []
			result = self.class.connection.get({
				:url => "#{CONTROLLER}/#{self[:id]}/submission"
			})
			result["submissions"].each {|s|
				submissions << ((FormStack::Submission.new).attributes = s)
			}
			return submissions
		end

		# https://www.formstack.com/developers/api/resources/submission#form/:id/submission_POST
		def create_submission(attrs = {})
			result = self.class.connection.post({
				:url => "#{CONTROLLER}/#{self[:id]}/submission",
				:params => attrs
			})
			return result
		end

		# confirmations

		# https://www.formstack.com/developers/api/resources/confirmation#form/:id/confirmation_GET
		def confirmations
			confirmations = []
			result = self.class.connection.get({
				:url => "#{CONTROLLER}/#{self[:id]}/confirmation"
			})
			result["confirmations"].each {|s|
				confirmations << ((FormStack::Confirmation.new).attributes = s)
			}
			return confirmations
		end

		# https://www.formstack.com/developers/api/resources/confirmation#form/:id/confirmation_POST
		def create_confirmation(attrs = {})
			result = self.class.connection.post({
				:url => "#{CONTROLLER}/#{self[:id]}/confirmation",
				:params => attrs
			})
			return result
		end

		# webhooks

		# https://www.formstack.com/developers/api/resources/webhook#form/:id/webhook_GET
		def webhooks
			webhooks = []
			result = self.class.connection.get({
				:url => "#{CONTROLLER}/#{self[:id]}/webhook"
			})
			result["webhooks"].each {|s|
				webhooks << ((FormStack::WebHook.new).attributes = s)
			}
			return webhooks
		end


		# https://www.formstack.com/developers/api/resources/webhook#form/:id/webhook_POST
		def create_webhook(attrs = {})
			result = self.class.connection.post({
				:url => "#{CONTROLLER}/#{self[:id]}/webhook",
				:params => attrs
			})
			return result
		end
	end
end