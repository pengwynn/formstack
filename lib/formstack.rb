# require all dependencies
dir = Dir[File.dirname(__FILE__) + '/formstack']
require "#{dir}/connection.rb"
require "#{dir}/connection/http.rb"
require "#{dir}/connection/oauth_connection.rb"

require "#{dir}/extensions/attr_accessor.rb"

require "#{dir}/errors.rb"
require "#{dir}/restful_resource.rb"
require "#{dir}/form.rb"
# some reason, FormStack::Form::CONTROLLER isn't generated
FormStack::Form.const_set :CONTROLLER, "form" if !FormStack::Form.const_defined?(:CONTROLLER)


require "#{dir}/version.rb"

module FormStack
  class << self

    attr_accessor :link

    def configure(&block)
      self.link ||= OauthConnection.new
      yield(link) if block_given?
    end 

    def connection
    	raise FormStack::Error::NoConnection if @link.nil?
    	return @link
    end

    def connection=(connection)
    	@link = connection
    end

  end
end
