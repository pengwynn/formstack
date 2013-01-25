RESOURCE_NAMES = [
	"Field",
	"Submission",
	"Notification",
	"Confirmation",
	"Webhook"
]

module FormStack

	RESOURCE_NAMES.each {|class_name|

		const_set(
			"#{class_name}", 
			klass = Class.new(HashAttributeClass) do
				const_set :CONTROLLER, class_name.downcase

				@attributes = {}

				def self.find(id)
					result = FormStack.connection.get({
						:url => "#{CONTROLLER}/#{id}"
					})
					f = class_name.constantize.new
					f.attributes = result
					return f
				end

				def self.update(id, attrs = {})
					
				end

				def self.destroy(id)
					
				end

			end
		) 

	}
end
