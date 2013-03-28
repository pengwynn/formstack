# Helps regular classes imitate something like an ActiveRecord Model
class HashAttributeClass  
	attr_accessor :attributes

	def initialize(attributes = {})
		@attributes = attributes.symbolize_keys
	end

	# @param [Symbol] attribute
	def [](attribute)
		result = @attributes[attribute.to_sym]
	end

	# for if we want to create a bunch of getters and setters for the key-value pairs
	# in @attributes
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