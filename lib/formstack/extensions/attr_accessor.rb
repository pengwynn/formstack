# Helps regular classes imitate something like an ActiveRecord Model
class HashAttributeClass  
	attr_accessor :attributes

	def initialize()
		@attributes = {}
	end

	def [](attribute)
		self.send(attribute.to_s)
	end

	def self.hash_attr_accessor(*accessors) 
		accessors.each do |m| 
			define_method(m)       { @attributes[m] }
			define_method("#{m}=") { |val| 	@attributes[m]=val }
		end 
	end 

	def defined_attributes
		result = {}
		@attributes.each {|k, v| result[k] = v if !v.nil? }
		return result
	end

	def attribute_keys
		@attributes_hash.keys
	end

	def attributes=(hash)
		hash.each { |k, value| self.send("#{k}=", value) if respond_to?("#{k}=") }
	end
end