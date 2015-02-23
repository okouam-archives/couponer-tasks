module Couponer
  module Domain 
    class Post

      def self.create(title, description = nil, post_type = nil, metadata)
        custom_fields = []
        metadata.each do |key, value|
          custom_fields << {:key => key, :value => value}
        end
        
        body =  {
          :post_title => title, 
          :post_name => title,
          :custom_fields => custom_fields
        }
        
        body[:post_excerpt] = body[:post_content] = description unless description.nil?
        body[:post_type] = post_type unless post_type.nil?          
        api = Couponer::API.new.client
        api.newPost({:content => body})
      end

    end
  end
end

