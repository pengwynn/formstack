# require all dependencies
Dir[File.dirname(__FILE__) + '/formstack/**/*.rb'].each {|file| require file }

module FormStack
  class << self

    attr_accessor :connection

    def configure(&block)
      self.connection ||= OauthConnection.new
      yield(connection) if block_given?
    end 

  end
end
