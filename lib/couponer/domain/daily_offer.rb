require 'stringex'

module Couponer
  module Domain 
    class DailyOffer

      def self.create(title, description, metadata, terms_names)
        
        pp terms_names
        
        Couponer::Domain::TermTaxonomy.assign(terms_names)      
        
        custom_fields = []
        
        if metadata
          metadata.each do |key, value|
            custom_fields << {:key => key, :value => value} if value
          end
        end
        
        body =  {
          :post_title => title, 
          #:post_type => 'daily_offer',
          :post_status => 'publish',
          :post_name => title.to_url,
          :custom_fields => custom_fields,
          :terms_names => {'category' => terms_names.values.flatten}
        }
        
        body[:post_excerpt] = body[:post_content] = description     
        api = Couponer::API.new.client
        
        pp body[:post_title]
        
        api.newPost({:content => body})
      end

    end
  end
end

