# Based on https://github.com/TinderBox/rightsignature-api/blob/master/lib/rightsignature/connection.rb
module FormStack
	class Connection
		include FormStack::ConnectionHelpers

		HEADERS_ACCEPT = {
			:json => "application/json",
			:xml => "application/xml"
		}

		HEADERS_CONTENT_TYPE = {
			:json => "application/json",
			:xml => "application/xml"
		}

		attr_accessor :debug
		attr_accessor :configuration
		attr_accessor :oauth2_connection

		# sets up an oauth2 connection
		def initialize(creds = {})
			@configuration = {}
			FormStack::Oauth2Connection.keys.each do |key|
				@configuration[key] = creds[key].to_s
			end

			@oauth2_connection = FormStack::Oauth2Connection.new(@configuration)
			@host = FormStack::Oauth2Connection::BASE_URL
			@configuration
		end

		# set token
		def access_token=(token)
			@configuration[:access_token] = token
		end
	

	    # Checks if credentials are set for OAuth2 or other service if later added
		def check_credentials
			raise "Please set load_configuration with #{FormStack::Oauth2Connection.keys.join(',')}" unless has_oauth2_credentials?
		end

	    # Checks if OAuth credentials are set. Does not validate creds with server.
		def has_oauth2_credentials?
			return false if @configuration.nil?
			FormStack::Oauth2Connection.keys.each do |key|
				# check if credentials exist or if they are just white space
				return false if @configuration[key].nil or @configuration[key].match(/^\s*$/)
			end
		end


		def method_missing(meth, *args, &block)
			method_name = meth.to_s

			if "forms" == method_name
				FormStack::Form.connection = self
				FormStack::Form
			elsif "fields" == method_name
				FormStack::Field.connection = self
				FormStack::Field
			elsif "submissions" == method_name
				FormStack::Submission.connection = self
				FormStack::Submission
			elsif "notifications" == method_name
				FormStack::Notification.connection = self
				FormStack::Notification
			elsif "confirmations" == method_name
				FormStack::Confirmation.connection = self
				FormStack::Confirmation
			elsif "webhooks" == method_name
				FormStack::WebHook.connection = self
				FormStack::WebHook
			else
				super
			end
		end
	end
end