require 'bundler'
require 'bundler/version'
require 'lib/formstack'

Gem::Specification.new do |s|
  s.name = %q{formstack}
  s.version = FormStack::VERSION
  # s.platform    = Gem::Platform::RUBY
  # s.required_rubygems_version = ">= 1.3.6"
  s.authors = ["Wynn Netherland, L. Preston Sego III"]
  s.date = %q{2010-05-23}
  s.description = %q{Wrapper for the Formstack API}
  s.email = ["wynn.netherland@gmail.com", "preston@gettinderbox.com"]
  s.files = Dir.glob("{lib}/**/*")
  s.homepage = %q{http://github.com/TinderBox/formstack}
  s.require_paths = ["lib"]
  # s.rubygems_version = %q{1.3.6}
  s.summary = %q{Wrapper for the Formstack API}
  s.test_files = [
    "test/helper.rb",
     "test/formstack_test.rb"
  ]

end

