# require 'lib/formstack'

$:.push File.expand_path("../lib", __FILE__)
require "formstack/version"

# this gem may or may not be 'subtly' based off the rightsignature-api gem
# thanks RightSignature!
Gem::Specification.new do |s|
  s.name = %q{formstack}
  s.version = FormStack::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors = ["L. Preston Sego III"]
  s.description = %q{Wrapper for the Formstack API with as much conversion to objects as I care to do!}
  s.summary = %q{Wrapper for the Formstack API}
  s.email = ["preston@gettinderbox.com"]
  s.files = `git ls-files`.split("\n")
  s.executables = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.homepage = %q{http://github.com/TinderBox/formstack}
  s.require_path = "lib"

  s.add_dependency "bundler"
  s.add_dependency "json"
  s.add_dependency "awesome_print"
  s.add_dependency "curb"
  s.add_dependency "active_support"
end

