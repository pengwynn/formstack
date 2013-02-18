module FormStack

	# FormStack oauth documentation
	# https://www.formstack.com/developers/api/authorization
	class Oauth2Connection
		# consumer_key and consumer_secret are defined by FormStack as
		# client_id and client_secret respectievly
		#
		# according to http://oauth.rubyforge.org/, consumer is the same as client
		# since client can be ambiguous, we are going to use 'consumer'.
		# but consumer is just another word for "your application"
		# really, I don't like any of these names... -_-
		#
		# response_token is the code return from FormStack 
		#
		# when registering an application.
		# the access_token is the toke from FormStack
		# which will be appended to the end of all the requests
		attr_accessor :consumer_key, :consumer_secret, :access_token, :response_code
		attr_accessor :return_url

		BASE_URL = "https://www.formstack.com/api/v2"
		AUTHORIZATION_ENDPOINT = BASE_URL + "/oauth2/authorize"
		TOKEN_ENDPOINT = BASE_URL + "/oauth2/token"

		# access_token is the token received from the third party after
		#   confirming that we have received the token_response
		#   and is the only thing we need to authorize requests
		# - this is sent along with all requests, and can be seen in cleartext
		#   - be sure to use HTTPS, or all of your user's oauth2 sessions are vulnerable
		#   - hope no one cares enough to run ssl_strip against your users
		def self.keys; [:access_token]; end

		# assigns all of the required parameters and creates a connection URL
		# with the authorization end point
		def initialize(args = {})
			# depending on which terminology you are using, allow some different options
			@consumer_key = (args[:consumer_key] or args[:client_id])
			@consumer_secret = (args[:consumer_secret] or args[:client_secret])
			@access_token = args[:access_token]
			@response_code = args[:response_code]
			@return_url = args[:return_url]
			@use_ssl = args[:use_ssl].nil? ? true : args[:use_ssl]
		end

		# creates the url to send users to where they will "Allow" an app
		# to connect with FormStack
		def authorize()
			url = AUTHORIZATION_ENDPOINT
			url += "?client_id=#{@consumer_key}"
			url += "&redirect_uri=#{@return_url}"
			url += "&response_type=code"
			return url
		end
		alias_method :connect_url, :authorize
		alias_method :redirect_url, :authorize

		def identify(response = {})
			@response_code = response[:code]
			state = response[:state]

			url = TOKEN_ENDPOINT
			url.gsub!("https", "http") if !@use_ssl

			data = {
				:client_id => @consumer_key,
				:code => @response_code,
				:client_secret => @consumer_secret,
				:redirect_uri => return_url,
				:grant_type => "authorization_code"
			}

			uri = URI.parse(url)
			http = Net::HTTP.new(uri.host)
			request = Net::HTTP::Post.new(uri.request_uri)
			request.set_form_data(data)
			response = http.request(request)

			response_body = JSON.parse(response.body)
			@access_token = response_body["access_token"]

			return @access_token
		end


		private

		# Raises exception if OAuth2 credentials are not set.
		def check_credentials
			raise "Please set #{keys.join(', ')}" unless has_oauth2_credentials?
		end

		# Checks if OAuth credentials are set.
		def has_oauth2_credentials?
			[@access_token].each do |cred| 
				return false if cred.nil? || cred.match(/^\s*$/)
			end

			true
		end

	end
end