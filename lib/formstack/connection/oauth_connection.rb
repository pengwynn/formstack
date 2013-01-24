module FormStack

	# FormStack oauth documentation
	# https://www.formstack.com/developers/api/authorization
	class OauthConnection < FormStack::Connection
		require "curl"
		# client_id, and client_secret are defined by FormStack
		# when registering an application.
		# the access_token is the token response from FormStack
		# which will be appended to the end of all the requests
		attr_accessor :client_id, :client_secret, :access_token
		attr_accessor :return_url
		attr_accessor :use_ssl

		# assigns all of the required parameters and creates a connection URL
		# with the authorization end point
		def initialize
			@use_ssl = false
			# everything else is set via the FormStack.configure block

			super(@access_token)
			FormStack.connection = self
		end

		# creates the url to send users to where they will "Allow" an app
		# to connect with FormStack
		def connect
			url = FormStack::Connection::AUTHORIZATION_ENDPOINT
			url += "?client_id=#{self.client_id}"
			url += "&redirect_uri=#{return_url}"
			url += "&response_type=code"
			ap url
			return url
		end
		alias_method :connect_url, :connect
		alias_method :redirect_url, :connect

		def identify(response = {})
			code = response[:code]
			state = response[:state]

			url = FormStack::Connection::TOKEN_ENDPOINT
			url.gsub!("https", "http") if !use_ssl

			data = {
				:client_id => client_id,
				:code => code,
				:client_secret => client_secret,
				:redirect_uri => return_url,
				:grant_type => "authorization_code"
			}
			ap data
			# response = Curl::Easy.http_post(url, data.to_json)
			# response_body = JSON.parse(response.body_str)
			# access_token = response_body["access_token"]

			uri = URI.parse(url)

			http = Net::HTTP.new(uri.host)

			request = Net::HTTP::Post.new(uri.request_uri)
			request.set_form_data(data)
			response = http.request(request)


			response_body = JSON.parse(response.body)
			access_token = response_body["access_token"]
			return access_token
		end


	end
end