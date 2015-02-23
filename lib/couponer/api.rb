module Couponer
  
  class API 
    
    attr_reader :client
  
    def initialize
      username = ENV['COUPONER_USERNAME']
      password = ENV['COUPONER_PASSWORD']
      host = ENV['COUPONER_HOST']
      raise "Please set the environment variable COUPONER_USERNAME" if username.nil? 
      raise "Please set the environment variable COUPONER_PASSWORD" if password.nil? 
      raise "Please set the environment variable COUPONER_HOST" if host.nil? 
      @client = Rubypress::Client.new(:host => host, :username => username, :password => password)
    end
  
  end
  
end