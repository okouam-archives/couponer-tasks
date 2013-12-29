require 'httpclient'
require 'zlib'
require 'json'
require 'sequel'
require 'logger'
require 'ruby-wpdb'

module Amazon

  class DealFinder

    def initialize
        @logger = Logger.new(STDOUT)
    end

    def find_deals(login, password, filename)
      @logger.info "Finding deals from Amazon Local using login #{login} and password #{password}"
      download_file(login, password, filename)
      WPDB.init('mysql2://root:com99123@localhost/wordpress956')
      parse_deals(filename)
      @logger.info "Deal retrieval is complete"
    end

    def download_file(login, password, filename)
      @logger.info "Downloading to the file #{filename}"
      `curl --location -o #{filename} --user #{login}:#{password} --digest -k "https://assoc-datafeeds-eu.amazon.com/datafeed/getFeed?filename=GB_localdeals.json.gz`
      @logger.info "Amazon Local deals downloaded"
    end

    def parse_deals(filename)
      Zlib::GzipReader.open(filename) do |gz|
        contents = JSON.parse(gz.read)
        deals = contents["deals"]
        @logger.info "Parsing #{deals.length} deals"
        for deal in deals do
          post = create_deal(deal)
          create_categories(post, deal["category"]["path"])
          create_geographies(post, deal["geographies"])
          create_redemption_locations(post, deal["redemptionLocations"])
        end
        gz.close
      end
    end

    def create_categories(post, categories)
      categories.each do |category|
        term = WPDB::Term.create(:name => category)
        taxonomy = WPDB::TermTaxonomy.create(:term_id => term.term_id, :taxonomy => 'category')
        post.add_termtaxonomy(taxonomy)
        post.save
      end
    end

    def create_geographies(post, geographies)
      geographies.each do |geography|
        term = WPDB::Term.create(:name => geography["displayName"])
        taxonomy = WPDB::TermTaxonomy.create(:term_id => term.term_id, :taxonomy => 'geography')
        post.add_termtaxonomy(taxonomy)
        post.save
      end
    end

    def create_redemption_locations(post, redemption_locations)
      redemption_locations.each do |location|
        post.add_post_meta(:meta_key => "location", :meta_value => location)
        post.save
      end
    end

    def create_deal(deal)
      post = WPDB::Post.create(:post_title => website_title, :post_content => description)
      post.add_post_meta(:meta_key => "asin", :meta_value => deal["asin"])
      post.add_post_meta(:meta_key => "merchant", :meta_value => deal["merchant"]["displayName"])
      post.add_post_meta(:meta_key => "imageUrl", :meta_value => deal["imageUrl"])
      post.add_post_meta(:meta_key => "finePrint", :meta_value => deal["finePrint"])
      post.add_post_meta(:meta_key => "offerEndTime", :meta_value => deal["offerEndTime"])
      post.add_post_meta(:meta_key => "price", :meta_value => deal["options"][0]["price"]["amountInBaseUnit"])
      post.add_post_meta(:meta_key => "value", :meta_value => deal["options"][0]["value"]["amountInBaseUnit"])
      post.save
    end

  end

end
