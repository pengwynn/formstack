require 'httparty'
require 'hashie'

Hash.send :include, Hashie::HashExtensions

# require all dependencies
Dir[File.dirname(__FILE__) + '/formstack/**/*.rb'].each {|file| require file }

module FormStack
  
  VERSION = "0.0.1".freeze

  class << self

    attr_accessor :connection

    def configure(&block)
      self.connection ||= OauthConnection.new
      yield(connection) if block_given?
    end 

  end
end
