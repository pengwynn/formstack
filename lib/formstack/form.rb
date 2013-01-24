module FormStack
	class Form < HashAttributeClass

		CONTROLLER = "form"

		@attributes = {}

		hash_attr_accessor :id, :fields, :notifications#,
							# :name, :viewkey, :views, :created, :deleted, :submissions

		def initialize()
			 # create class where key-value pairs in the @attributes hash
			 # function as actial attributes / methods of a model
			super()
		end

		# https://www.formstack.com/developers/api/resources/form#form_GET
		def self.all
			result = FormStack.connection.get({
				:url => CONTROLLER
			})
			return result["forms"]
		end

		# https://www.formstack.com/developers/api/resources/form#form_POST
		def self.create(attrs = {})
			result = FormStack.connection.post({
				:url => CONTROLLER,
				:params => self.define_attributes.merge(attrs)
			})
		end

		# https://www.formstack.com/developers/api/resources/form#form/:id_GET
		def self.find(id)
			result = FormStack.connection.get({
				:url => "#{CONTROLLER}/#{id}"
			})
			f = FormStack::Form.new
			f.attributes = result
		end

		# https://www.formstack.com/developers/api/resources/form#form/:id_PUT
		def self.update(id, args)

		end

		# https://www.formstack.com/developers/api/resources/form#form/:id_DELETE
		def self.destroy(id)

		end

		# https://www.formstack.com/developers/api/resources/form#form/:id/copy_POST
		def self.copy(id)
			result = FormStack.connection.post({
				:url => "#{CONTROLLER}/#{id}"
			})
			f = FormStack::Form.new
			f.attributes = result
		end

		# set up aliases
		class << self
			alias :forms  :all
			alias :index  :all
			alias :post   :create
			alias :get    :find
			alias :show   :find
			alias :put    :update
			alias :delete :destroy
		end

	end
end