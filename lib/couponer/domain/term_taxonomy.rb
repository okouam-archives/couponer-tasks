require 'awesome_print'

module Couponer
  module Domain
    class TermTaxonomy
   
      @@categories = {}
      @@lookup = {}
      
      def self.assign(term_names)
        api = Couponer::API.new.client
        cache_taxonomies(api) unless @@lookup.entries.any?
        self.ensure_terms_exist(api, term_names)
      end
   
      private
      
      def self.cache_taxonomies(api)
        terms = api.getTerms(:taxonomy => 'category')
        refresh(api, 'geography', terms)
        refresh(api, 'product', terms)
        terms.each do |term|
          parent_id = term['parent']
          name = term['name']
          @@categories[parent_id] << name if @@lookup.has_key?(parent_id)
        end
      end
      
      def self.ensure_terms_exist(api, term_names)
        term_names.each do |parent, terms|
          parent_id = @@lookup[parent]
          raise "Parent term <#{parent}> does not exist." unless parent_id
          terms.each do |term|
            cache = @@categories[parent_id]
            unless cache.include?(term)
              api.newTerm(:content => {:name => term, :taxonomy => 'category', :parent => parent_id})
              cache << term 
            end 
          end
        end
      end
      
      def self.refresh(api, parent, terms)
        term = terms.find {|term| term['name'] == parent}
        id = term ? term['term_id'] : api.newTerm(:content => {:name => parent, :taxonomy => 'category'})
        @@lookup[id] = parent
        @@lookup[parent] = id
        @@categories[id] = []
      end
    
    end
  end
end