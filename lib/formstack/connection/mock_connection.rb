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