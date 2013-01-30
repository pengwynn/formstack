require 'bundler'
require 'bundler/version'

require "awesome_print"
require "json"

require 'lib/formstack'

Gem::Specification.new do |s|
  s.name = %q{formstack}
  s.version = FormStack::VERSION
  # s.platform    = Gem::Platform::RUBY
  s.authors = ["L. Preston Sego III"]
  s.date = %q{2010-05-23}
  s.description = %q{Wrapper for the Formstack API}
  s.email = ["preston@gettinderbox.com"]
  s.files = Dir.glob("{lib}/**/*")
  s.homepage = %q{http://github.com/TinderBox/formstack}
  s.require_paths = ["lib"]
  s.summary = %q{Wrapper for the Formstack API}
  s.test_files = [
    "test/helper.rb",
     "test/formstack_test.rb"
  ]

end

