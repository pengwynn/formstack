RESOURCE_NAMES = [
	"Form",
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

				def self.find(id)
					result = FormStack.connection.get({
						:url => "#{self.const_get(:CONTROLLER)}/#{id}"
					})
					f = self.new(result)
					return f
				end

				def update(attrs = {})
					self.class.update(self[:id], attrs)
				end

				def self.update(id, attrs = {})
					result = FormStack.connection.put({
						:url => "#{self.const_get(:CONTROLLER)}/#{id}",
						:params => attrs
					})
				end

				def destroy()
					self.class.destroy(self[:id])
				end

				def self.destroy(id)
					result = FormStack.connection.delete({
						:url => "#{self.const_get(:CONTROLLER)}/#{id}"
					})
				end

			end
		) 

	}

 def constantize(camel_cased_word)
        names = camel_cased_word.split('::')
        names.shift if names.empty? || names.first.empty?

        constant = Object
        names.each do |name|
          constant = constant.const_defined?(name) ? constant.const_get(name) : constant.const_missing(name)
        end
        constant
      end

end

