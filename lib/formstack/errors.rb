module FormStack
	class Error
		class NoConnection < StandardError; 
			def initialize(msg = "You must first connect to FormStack")
				super(msg)
			end
		end
	end
end