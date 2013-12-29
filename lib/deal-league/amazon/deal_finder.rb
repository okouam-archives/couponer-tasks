require 'zlib'
require 'json'
require 'logger'
require 'ruby-wpdb'
require 'logger/colors'
require 'securerandom'

module Amazon

  class DealFinder

    FEED_URL = 'https://assoc-datafeeds-eu.amazon.com/datafeed/getFeed?filename=GB_localdeals.json.gz'

    CURL_OPTS = '--location --digest -k --progress-bar'

    def find_deals(login, password, filename)

      @logger = Logger.new(STDOUT)

      # Number of deals found in the feed
      @deal_count = 0

      # Cache for geographies for faster data insertion
      @geographies = {}

      # Cache for categories for faster data insertion
      @categories = {}

      @logger.info "Finding deals from Amazon Local using login #{login} and password #{password}"

      download_file(login, password, filename)

      parse_deals(filename)

      @logger.info 'Deal retrieval is complete'

    end

    private

    def download_file(login, password, filename)

      @logger.info "Downloading to the file #{filename}"

      `curl #{CURL_OPTS} -o #{filename} --user #{login}:#{password} "#{FEED_URL}"`

      @logger.info 'Amazon Local deals downloaded'

    end

    def parse_deals(filename)
      Zlib::GzipReader.open(filename) do |gz|
        contents = JSON.parse(gz.read)
        deals = contents['deals']
        @logger.info "Parsing #{deals.length} deals"
        deals.each do |deal|
          begin
            @deal_count = @deal_count + 1
            post = create_deal(deal)
            create_categories(post, deal['category']['path'])
            create_geographies(post, deal['geographies'])
            create_redemption_locations(post, deal['redemptionLocations'])
          rescue => e
            @logger.error("Unable to parse deal #{@deal_count} with title #{deal['websiteTitle']} and ASIN #{deal['asin']} ending at #{Time.at(deal['offerEndTime'] / 1000)}")
            @logger.error(e)
          end
        end
        gz.close
      end
    end

    def create_categories(post, categories)
      categories.each do |category|
        term = WPDB::Term.find(:name => category)
        if term
          taxonomy = WPDB::TermTaxonomy.find(:term_id => term.term_id, :taxonomy => 'category')
        else
          term = WPDB::Term.create(:name => category) unless term
          taxonomy = WPDB::TermTaxonomy.create(:term_id => term.term_id, :taxonomy => 'category')
        end
        post.add_termtaxonomy(taxonomy)
        post.save
      end
    end

    def create_geographies(post, geographies)
      geographies.each do |geography|
        term = WPDB::Term.find(:name => geography['displayName'])
        if term
          taxonomy = WPDB::TermTaxonomy.find(:term_id => term.term_id, :taxonomy => 'geography')
        else
          term = WPDB::Term.create(:name => geography['displayName']) unless term
          taxonomy = WPDB::TermTaxonomy.create(:term_id => term.term_id, :taxonomy => 'geography')
        end
        post.add_termtaxonomy(taxonomy)
        post.save
      end
    end

    def create_redemption_locations(parent, redemption_locations)
      redemption_locations.each do |location|
        post = WPDB::Post.create(:post_title => SecureRandom.hex, :post_type => 'location')
        post.add_postmeta(:meta_key => 'addressPostalCode', :meta_value => location['addressPostalCode'])
        post.add_postmeta(:meta_key => 'addressStateOrProvince', :meta_value => location['addressStateOrProvince'])
        post.add_postmeta(:meta_key => 'addressStreet1', :meta_value => location['addressStreet1'])
        post.add_postmeta(:meta_key => 'addressStreet2', :meta_value => location['addressStreet2'])
        post.add_postmeta(:meta_key => 'latitude', :meta_value => location['latitude'])
        post.add_postmeta(:meta_key => 'longitude', :meta_value => location['longitude'])
        debugger
        post.add_postmeta(:meta_key => 'deal', :meta_value => parent.ID)
        post.save
      end
    end

    def create_deal(deal)
      website_title = deal['websiteTitle']
      @logger.debug "Deal #{@deal_count}: #{website_title} ending at #{get_timestamp(deal['offerEndTime'])}"
      description = deal['description']
      post = WPDB::Post.create(:post_title => website_title, :post_content => description)
      post.add_postmeta(:meta_key => 'asin', :meta_value => deal['asin'])
      post.add_postmeta(:meta_key => 'merchant', :meta_value => deal['merchant']['displayName'])
      post.add_postmeta(:meta_key => 'imageUrl', :meta_value => deal['imageUrl'])
      post.add_postmeta(:meta_key => 'finePrint', :meta_value => deal['finePrint'])
      post.add_postmeta(:meta_key => 'offerEndTime', :meta_value => get_timestamp(deal['offerEndTime']))
      post.add_postmeta(:meta_key => 'price', :meta_value => deal['options'][0]['price']['amountInBaseUnit'])
      post.add_postmeta(:meta_key => 'value', :meta_value => deal['options'][0]['value']['amountInBaseUnit'])
      post.save
    end

    def get_timestamp(value)
      Time.at(value / 1000)
    end

  end

end
