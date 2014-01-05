$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))

require 'rspec'
require 'deal-league'

Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

def init_wordpress
  WPDB.init('mysql2://root:com99123@localhost/wordpress')
  posts = WPDB::Post.all
  posts.each do |post|
    post.destroy
  end
  terms = WPDB::Term.all
  terms.each do |term|
    term.destroy
  end
end
