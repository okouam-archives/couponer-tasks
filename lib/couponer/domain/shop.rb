module Couponer
  module Domain 
    class Shop

      def self.create(deal_id, location)
        
        custom_fields = [
          {:key => 'addressPostalCode', :value => location['addressPostalCode']},
          {:key => 'addressStateOrProvince', :value => location['addressStateOrProvince']},
          {:key => 'addressStreet1', :value => location['addressStreet1']},
          {:key => 'addressStreet2', :value => location['addressStreet2']},
          {:key => 'latitude', :value => location['latitude']},
          {:key => 'longitude', :value => location['longitude']},
          {:key => 'deal', :value => deal_id}
        ]
        
        body =  {
          :post_type => 'shop',
          :post_status => 'publish',
          :custom_fields => custom_fields
        }
        
        title = location['addressStreet1']
        content = location['addressStreet2'] 
        content = content + '<br/>' + location['addressStateOrProvince'] if location['addressStateOrProvince']
        content = content + '<br/>' + location['addressPostalCode'] if location['addressPostalCode']
        
        body[:post_excerpt] = body[:post_content] = content
        body[:post_name] = title.to_url
        body[:post_title] = title   
        api = Couponer::API.new.client
        pp body
        api.newPost({:content => body})
        
      end

    end
  end
end

