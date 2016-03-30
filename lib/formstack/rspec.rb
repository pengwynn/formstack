# to be included for apps using this gem and testing their formstack integration
module RSpec
	# mock everything
	objs = {
		:forms => FormStack::Form,
		:fields => FormStack::Field,
		:submissions => FormStack::Submission,
		:notifications => FormStack::Notification,
		:confirmations => FormStack::Confirmation,
		:webhooks => FormStack::Webhook
	}

	objs.each do |name, klass|
		FormStack::Connection.any_instance.stub(name).and_return(klass)
		# somehow make the id of this be the passed in id?
		klass.stub(:find) do |id|
			id = id.to_i
			raise ArgumentError, "id of '#{id}' is invalid" if !id or id < 1
			klass.new({:id => id})
		end

		klass.stub(:update) do |id, arg|
			id = id.to_i
			raise ArgumentError, "id of '#{id}' is invalid" if !id or id < 1
			klass.new({:id => id}.merge(arg))
		end

		klass.stub(:destroy) do |id|
			id = id.to_i
			raise ArgumentError, "id of '#{id}' is invalid" if !id or id < 1
			id
		end
	end

	# form specific things, since everything is based off the form
	FormStack::Form.stub(:all) do |num_things_to_return|
		num_things_to_return ||= 0
		# actual method doesn't take a param
		result = []
		num_things_to_return.times do
			result << FormStack.Form.new
		end
		result
	end

	FormStack::Form.stub(:copy) do |id|
		# this means that the copy command will always succeed...
		FormStack::Form.new({:id => id + 1})
	end

	form_instance_methods = {
		:fields => FormStack::Field,
		:submissions => FormStack::Submission,
		:confirmations => FormStack::Confirmation,
		:webhooks => FormStack::Webhook,
	}
	form_instance_methods_that_create = {
		:create_field => FormStack::Field,
		:create_submission => FormStack::Submission,
		:create_confirmations => FormStack::Confirmation,
		:create_webhook => FormStack::Webhook,
	}

	form_instance_methods.each do |meth, klass|
		FormStack::Form.any_instance.stub(meth) do |_, num_things_to_return|
			num_things_to_return ||= 0
			# actual method doesn't take a param
			result = []
			num_things_to_return.times do
				result << klass.new
			end
			result
		end
	end

	form_instance_methods_that_create.each do |meth, klass|
		FormStack::Form.any_instance.stub(meth) do |_, attrs, num_things_to_return|
			num_things_to_return ||= 1
			# actual method doesn't take this param
			result = nil
			num_things_to_return.times do
				result = klass.new({:id => 1}.merge(attrs))
			end
			result
		end
	end
end
