# require all dependencies
require "json"
require "awesome_print"

require "formstack/extensions/attr_accessor.rb"

require "formstack/errors.rb"
require "formstack/restful_resource.rb"
require "formstack/form.rb"

require "formstack/connection/http.rb"
require "formstack/connection/oauth2_connection.rb"
require "formstack/connection.rb"


# some reason, FormStack::Form::CONTROLLER isn't generated
FormStack::Form.const_set :CONTROLLER, "form" if !FormStack::Form.const_defined?(:CONTROLLER)

module FormStack

end
