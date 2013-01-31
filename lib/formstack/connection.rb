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

		def initialize(creds = {})
			@configuration = {}
			FormStack::Oauth2Connection.keys.each do |key|
				@configuration[key] = creds[key].to_s
			end

			@oauth2_connection = FormStack::Oauth2Connection.new(@configuration)
			@configuration
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


		def forms

		end

		def fields

		end

		def submissions

		end

		def notifications

		end

		def confirmations

		end

		def webhooks

		end


	end
end