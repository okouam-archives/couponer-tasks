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
      
      attr_accessor :deal_limit 

      FEED_URL = 'https://assoc-datafeeds-eu.amazon.com/datafeed/getFeed?filename=GB_localdeals.json.gz'
      CURL_OPTS = '--location --digest -k --progress-bar'

      def find_deals(login, password, filename = nil)
        fire(:started)
        filename = download_file(login, password, filename)
        parse_deals(filename)
        fire(:ended)
      end

      def parse_deals(filename)
        Zlib::GzipReader.open(filename) do |gz|
          contents = JSON.parse(gz.read)
          deals = contents['deals']
          fire(:products_found, deals.length)
          counter = 0
          deals.each do |deal|
            save_post(deal)
            counter = counter + 1
            break if @deal_limit && counter == @deal_limit 
          end
          gz.close
        end
      end

      private

      def save_post(deal)
        post_id = Couponer::Domain::DailyOffer.create(
            deal['websiteTitle'], 
            deal['description'],
            {
              'uniqueid' => deal['asin'],
              'merchant' => deal['merchant']['displayName'],
              'imageUrl' => deal['imageUrl'],
              'finePrint' => deal['finePrint'],
              'offerEndTime' => Time.at(deal['offerEndTime'] / 1000),
              'price' => deal['options'][0]['price']['amountInBaseUnit'],
              'value' => deal['options'][0]['value']['amountInBaseUnit']
            },
            {
              'product' => deal['category']['path'].map{|x|x.sub("&", "and")}, 
              'geography' => deal['geographies'].map{|x|x['displayName'].sub("&", "and")}
            })        
        deal['redemptionLocations'].each {|location| Couponer::Domain::Shop.create(post_id, location)}    
      end

      def download_file(login, password, filename)
        filename = filename || Tempfile.new('deal-league')
        fire(:download_started, login, password, filename)
        `curl #{CURL_OPTS} -o #{filename} --user #{login}:#{password} "#{FEED_URL}"`
        fire(:download_complete, filename)
        filename
      end

    end
  end
end
