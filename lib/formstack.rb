require 'httparty'
require 'hashie'

directory = File.expand_path(File.dirname(__FILE__))

Hash.send :include, Hashie::HashExtensions

module Formstack
  
  VERSION = "0.0.1".freeze

  
  class FormstackError < StandardError
    attr_reader :data

    def initialize(data)
      @data = data
      super
    end
  end
end

require File.join(directory, 'formstack', 'client')