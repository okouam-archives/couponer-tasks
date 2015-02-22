module Couponer
  module Domain 
    class Shop

      def self.create(deal_id, location)
        post = WPDB::Post.create(:post_title => SecureRandom.hex, :post_type => 'location')
        post.add_postmeta(:meta_key => 'addressPostalCode', :meta_value => location['addressPostalCode'])
        post.add_postmeta(:meta_key => 'addressStateOrProvince', :meta_value => location['addressStateOrProvince'])
        post.add_postmeta(:meta_key => 'addressStreet1', :meta_value => location['addressStreet1'])
        post.add_postmeta(:meta_key => 'addressStreet2', :meta_value => location['addressStreet2'])
        post.add_postmeta(:meta_key => 'latitude', :meta_value => location['latitude'])
        post.add_postmeta(:meta_key => 'longitude', :meta_value => location['longitude'])
        post.add_postmeta(:meta_key => 'deal', :meta_value => deal_id)
        post.save
      end

    end
  end
end

