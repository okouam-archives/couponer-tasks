require 'ruby-wpdb'

module ShopWindow

  class Handler

    def process(xml, logger, merchant_name)
      logger.info("Processing deals for #{merchant_name}")
      deal_count = save(xml, logger, merchant_name)
      logger.info("Processed #{deal_count} deals for #{merchant_name}")
      deal_count
    end

    def save(contents, logger, merchant_name)
      xml = Nokogiri::XML(contents)
      counter = 0
      products = xml.css('prod[in_stock="yes"]')
      logger.info("#{products.size} available products have been identified for #{merchant_name}")
      products.each do |product|
        begin
          post = WPDB::Post.create(:post_title => "#{product['id']}: #{product.css('name').text}", 
            :to_ping => '',
            :post_modified_gmt => Time.now,
            :post_modified => Time.now,
            :pinged => '',
            :post_content_filtered => product.css('desc').text,
            :post_content => product.css('desc').text,
            :post_excerpt => product.css('desc').text)
          post.add_postmeta(:meta_key => 'uniqueid', :meta_value => product['id'])
          post.add_postmeta(:meta_key => 'merchant', :meta_value => merchant_name)
          post.add_postmeta(:meta_key => 'imageUrl', :meta_value => product.css('awImage').text)
          post.add_postmeta(:meta_key => 'finePrint', :meta_value => product.css('spec').text)
          post.add_postmeta(:meta_key => 'offerStartTime', :meta_value => product.css('valFrom').text)
          post.add_postmeta(:meta_key => 'offerEndTime', :meta_value => product.css('valTo').text)
          post.add_postmeta(:meta_key => 'price', :meta_value => product.css('buynow').text)
          post.add_postmeta(:meta_key => 'purchaseUrl', :meta_value => product.css('awTrack').text)
          post.add_postmeta(:meta_key => 'value', :meta_value => product.css('rrp').text || product.css('store').text)
          Categories.create(post, product.css('awCat').text)
          Geographies.create_from_merchant_url(post, product.css('mLink').text, merchant_name)
          post.save
          counter = counter + 1
        rescue => e
          logger.error("Unable to parse deal #{counter} with title #{product.css('name').text} and UniqueID #{product['id']}")
          logger.error(e)
        end
      end
      counter
    end

  end

end