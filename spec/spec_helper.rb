$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'deal-league'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def init_wordpress
  username = ENV['COUPONER_USERNAME']
  password = ENV['COUPONER_PASSWORD']
  host = ENV['COUPONER_HOST']
  database = ENV['COUPONER_DATABASE']
  
  if username.nil? 
    raise "Please set the environment variable COUPONER_USERNAME"
  end
  
  if password.nil? 
    raise "Please set the environment variable COUPONER_PASSWORD"
  end
  
  if host.nil? 
    raise "Please set the environment variable COUPONER_HOST"
  end
  
  if database.nil? 
    raise "Please set the environment variable COUPONER_DATABASE"
  end
  
  WPDB.init("mysql2://#{username}:#{password}@#{host}/#{database}")
  posts = WPDB::Post.all
  posts.each do |post|
    post.destroy
  end
  terms = WPDB::Term.all
  terms.each do |term|
    term.destroy
  end
end
