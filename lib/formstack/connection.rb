module FormStack
	class Connection

		HEADERS_ACCEPT = {
			:json => "application/json",
			:xml => "application/xml"
		}

		HEADERS_CONTENT_TYPE = {
			:json => "application/json",
			:xml => "application/xml"
		}

		BASE_URL = "https://www.formstack.com/api/v2/"
		AUTHORIZATION_ENDPOINT = BASE_URL + "oauth2/authorize"
		TOKEN_ENDPOINT = BASE_URL + "oauth2/token"

		attr_accessor :host
		attr_accessor :debug
		attr_accessor :access_token

		def initialize(access_token = nil)
			@access_token = access_token if (not access_token.nil?)
			set_host(BASE_URL)
			FormStack.connection = self
		end

		# sets the host for use with the {get}, {post}, and {upload} methods
		# @param [String] new_host the host to use
		def set_host(new_host)
			@host = new_host.split("").last == "/" ? new_host.chop : new_host
		end

		def debug=(d)
			@debug = d
		end

		def get(o = {})
			url = o[:url]
			params = (o[:params] or o[:data] or {})
			format = (o[:format] or :json)

			param_string = params.empty? ? "" : QueryParams.encode(params)
			url_string = "#{@host}/#{url.to_s}.#{format.to_s}?#{param_string}"

			ap url_string if @debug

			response = Curl::Easy.perform(url_string) do |curl|
				curl.headers["Accept"] = HEADERS_ACCEPT[format]
				curl.headers["Content-Type"] = HEADERS_CONTENT_TYPE[format]
				curl.headers["Authorization"] = "Bearer #{@access_token}"
			end
			code = response.response_code

			response = {:code => code, :response => response.body_str }
			return parse_response(response)
		end

		def post(o = {})
			url = o[:url]
			data = (o[:data] or o[:params] or {})
			format = (o[:format] or :json)

			code = -1
			url = "#{@host}/#{url.to_s}.#{format.to_s}"

			ap url if @debug
			req = Curl::Easy.http_post(url, data.send("to_#{format.to_s}")) do |curl|
				curl.headers["Accept"] = HEADERS_ACCEPT[format]
				curl.headers["Content-Type"] = HEADERS_CONTENT_TYPE[format]
				curl.headers["Authorization"] = "Bearer #{@access_token}"
				curl.on_complete {|response, err|
					code = response.response_code
				}
			end

			response = {:code => code, :response => req.body_str }
			return parse_response(response)
		end

		def put

		end

		def delete

		end

		def upload(o = {})
			url = o[:url] or @default_host
			data = (o[:data] or o[:params] or o[:fields] or {})
			format = (o[:format] or :json)
			file_name = o[:file_name]
			file_field_name = o[:file_field_name]

			url = "#{@host}/#{url}.#{format.to_s}?access_token=#{@access_token.to_s}"		

			ap url if @debug

			post_fields = []
			post_fields << Curl::PostField.file(file_field_name, file_name)
			data.each do |name,obj|
				if obj and obj.is_a?(Hash)
					obj.each do |attribute, value|
						post_fields << Curl::PostField.content("#{name}[#{attribute}]", value)	
					end				
				end
			end

			c = Curl::Easy.new(url)
			c.multipart_form_post = true
			c.http_post(post_fields)

			response = {:code => c.response_code, :response => c.body_str}
			return parse_response(response)
		end

		def parse_response(response)
			body = response[:response]
			status = response[:code]
			ap body if @debug
			begin
				if status >= 400
					raise FormStack::HTTP[status]
				end
				return {} if body == " " and status >= 200 and status < 300
				return JSON.parse(body)
			rescue => e
				ap e.message
				ap body
				ap status
				raise e
			end
		end
	end
end