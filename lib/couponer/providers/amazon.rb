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
        filename = filename || Tempfile.new('deal-league')
        download_file(login, password, filename)
        deal_count = parse_deals(filename)
        @logger.info 'Deal retrieval is complete'
        deal_count
      end

      def self.parse_deals(filename)
        deal_count = 0
        Zlib::GzipReader.open(filename) do |gz|
          contents = JSON.parse(gz.read)
          deals = contents['deals']
          fire(:products_found, deals.length)
          deals.each do |deal|
            begin
              deal_count = deal_count + 1
              deal_id = create_deal(deal)
              TermTaxonomy.assign(deal_id, deal['category']['path'], 'category')
              TermTaxonomy.assign(deal_id, deal['geographies'].map{|x|x['displayName']}, 'geography')
              deal['redemptionLocations'].each {|location| Shop.create(deal_id, location)}
            rescue => e
              @logger.error("Unable to parse deal #{deal_count} with title #{deal['websiteTitle']} and ASIN #{deal['asin']} ending at #{Time.at(deal['offerEndTime'] / 1000)}")
              @logger.error(e)
            end
          end
          gz.close
          deal_count
        end
      end

      private

      def self.download_file(login, password, filename)
        fire(:download_started, login, password, filename)
        `curl #{CURL_OPTS} -o #{filename} --user #{login}:#{password} "#{FEED_URL}"`
        fire(:download_complete)
      end

      def self.create_deal(deal)
        website_title = deal['websiteTitle']
        description = deal['description']
        post = WPDB::Post.create(:post_title => website_title, 
          :to_ping => '',
          :pinged => '',
          :post_modified => Time.now,
          :post_modified_gmt => Time.now,
          :post_content_filtered => description,
          :post_content => description, 
          :post_excerpt => description)
        post.add_postmeta(:meta_key => 'uniqueid', :meta_value => deal['asin'])
        post.add_postmeta(:meta_key => 'merchant', :meta_value => deal['merchant']['displayName'])
        post.add_postmeta(:meta_key => 'imageUrl', :meta_value => deal['imageUrl'])
        post.add_postmeta(:meta_key => 'finePrint', :meta_value => deal['finePrint'])
        post.add_postmeta(:meta_key => 'offerEndTime', :meta_value => get_timestamp(deal['offerEndTime']))
        post.add_postmeta(:meta_key => 'price', :meta_value => deal['options'][0]['price']['amountInBaseUnit'])
        post.add_postmeta(:meta_key => 'value', :meta_value => deal['options'][0]['value']['amountInBaseUnit'])
        post.save
        post.id
      end

    end
  end
end
