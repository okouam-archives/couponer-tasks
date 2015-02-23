require 'zlib'
require 'json'
require 'logger'
require 'ruby-wpdb'
require 'logger/colors'
require 'eventful'
require 'securerandom'

module Couponer
  module Providers
    class Amazon
      include Eventful

      FEED_URL = 'https://assoc-datafeeds-eu.amazon.com/datafeed/getFeed?filename=GB_localdeals.json.gz'
      CURL_OPTS = '--location --digest -k --progress-bar'

      def self.find_deals(login, password, filename = nil)
        fire(:started)
        filename = download_file(login, password, filename)
        parse_deals(filename)
        fire(:ended)
      end

      def self.parse_deals(filename)
        Zlib::GzipReader.open(filename) do |gz|
          contents = JSON.parse(gz.read)
          deals = contents['deals']
          fire(:products_found, deals.length)
          deals.each do |deal|
            begin
              post = Post.create(
                  deal['websiteTitle'], 
                  deal['description'],
                  nil,
                  {
                    'uniqueid' => deal['asin'],
                    'merchant' => deal['merchant']['displayName'],
                    'imageUrl' => deal['imageUrl'],
                    'finePrint' => deal['finePrint'],
                    'offerEndTime' => Time.at(deal['offerEndTime'] / 1000),
                    'price' => deal['options'][0]['price']['amountInBaseUnit'],
                    'value' => deal['options'][0]['value']['amountInBaseUnit']
                  })        
                        
              TermTaxonomy.assign(post['post_id'], {
                'category' => deal['category']['path'], 
                'geography' => deal['geographies'].map{|x|x['displayName']}
                })
              
              deal['redemptionLocations'].each {|location| Shop.create(post['post_id'], location)}
            rescue => e
              fire(:error, deal, e)
            end
          end
          gz.close
        end
      end

      private

      def self.download_file(login, password, filename)
        filename = filename || Tempfile.new('deal-league')
        fire(:download_started, login, password, filename)
        `curl #{CURL_OPTS} -o #{filename} --user #{login}:#{password} "#{FEED_URL}"`
        fire(:download_complete, filename)
      end

    end
  end
end
