module FormStack
	class Submission < HashAttributeClass

		def value_of(id)
			data = self["data"]
			data.each do |d|
				if d["field"].to_s == id.to_s
					return d["value"]
				end
			end
			return nil
		end
	end
end