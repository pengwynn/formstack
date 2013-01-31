# require all dependencies
require "json"
require "awesome_print"

dir = Dir[File.dirname(__FILE__) + '/formstack']

require "#{dir}/extensions/attr_accessor.rb"

require "#{dir}/errors.rb"
require "#{dir}/restful_resource.rb"
require "#{dir}/form.rb"

require "#{dir}/connection/http.rb"
require "#{dir}/connection/oauth2_connection.rb"
require "#{dir}/connection.rb"


# some reason, FormStack::Form::CONTROLLER isn't generated
FormStack::Form.const_set :CONTROLLER, "form" if !FormStack::Form.const_defined?(:CONTROLLER)


require "#{dir}/version.rb"

module FormStack

end
