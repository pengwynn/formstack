begin
  require 'rspec/core/rake_task'

  RSpec::Core::RakeTask.new(:spec)
  task :default => :spec

  desc "Run tests with SimpleCov"
  RSpec::Core::RakeTask.new(:coverage) do |t|
    ENV['COVERAGE'] = "true"
  end
rescue LoadError
  #STDERR.puts "rspec is not available"
end
