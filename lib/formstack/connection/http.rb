module FormStack
	# shorthand helpers for status codes
	class HTTP
		def self.status_name(code)
				ActionController::StatusCodes::STATUS_CODES[code]
		end

		def self.[](code)
			if code.is_a?(Symbol)
				return ActionController::StatusCodes::SYMBOL_TO_STATUS_CODE[code] #returns code
			elsif code.is_a?(Fixnum)
				return ActionController::StatusCodes::STATUS_CODES[code] #returns name
			elsif code.is_a?(String)
				return ActionController::StatusCodes::STATUS_CODES.index(code) #returns code
			else 
				raise "I don't know what to do with this! T_T"
			end
		end
	end
end