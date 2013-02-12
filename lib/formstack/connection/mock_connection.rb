module FormStack
	module ConnectionHelpers
		def simple_request(method, url, data, query_string = "", format = :json)
			require 'webmock/rspec'
			has_id = url =~ /form|submission\/\d/

			file_name = "form" if has_id
			file_name = "forms" if url == "form"
			file_name = "fields" if url =~ /field/
			file_name = "webhook" if url =~ /webhook/

			file_response = File.read(File.dirname(__FILE__) + "/../../../test/fixtures/#{file_name}.json")

			url = "#{@host}/#{url.to_s}.#{format.to_s}"

			data = data.send("to_#{format.to_s}") if data

			args = url
			args = ([args] << data) if data

			WebMock.stub_request(:get, url).to_return(:body => file_response) if method == :get
			WebMock.stub_request(:post, url).to_return(:body => {
			    "id" => "12345",
			}.to_json) if method == :post


			req = Curl::Easy.send("http_#{method.to_s}", *args) do |curl|
				curl.headers["Accept"] = FormStack::Connection::HEADERS_ACCEPT[format]
				curl.headers["Content-Type"] = FormStack::Connection::HEADERS_CONTENT_TYPE[format]
				curl.headers["Authorization"] = "Bearer #{@configuration[:access_token]}"
				curl.verbose = @debug
			end


			response = {:code => req.response_code, :response => req.body_str}
			return parse_response(response)
		end
	end
end

require "webmock"
require "webmock/rspec"
include WebMock::API

stub_request(:get, "https://www.formstack.com/api/v2/form/2.json").
  with(:headers => {'Accept'=>'application/json', 'Authorization'=>'Bearer blah', 'Content-Type'=>'application/json'}).
  to_return(:status => 200, :body => {}.to_json, :headers => {})

stub_request(:post, "http://www.formstack.com/api/v2/oauth2/token").
  with(:body => {"grant_type"=>"authorization_code", "client_id"=>"11243", "redirect_uri"=>"http://test2.tinderbox.vhost/integrations/formstack/oauth_token", "code"=>"", "client_secret"=>"be517af2b3"},
       :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/x-www-form-urlencoded'}).
  to_return(:status => 200, :body => {"access_token" => "2"}.to_json, :headers => {})