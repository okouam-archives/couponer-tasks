require 'awesome_print'

module Couponer
  module Domain
    class TermTaxonomy
   
      def self.assign(deal_id, term_names)
        api = Couponer::API.new.client
        self.ensure_taxonomy_exists(api, term_names.keys)
        self.ensure_terms_exist(api, term_names)
        api.editPost(:post_id => deal_id, :content => {:terms_names => term_names})
      end
   
      private
      
      def self.ensure_terms_exist(api, term_names)
        term_names.each do |taxonomy, terms|
          terms.each do |term|
            ensure_term_exists(api, term, taxonomy)   
          end
        end
      end
      
      def self.ensure_term_exists(api, term, taxonomy)
        unless api.getTerms(:taxonomy => taxonomy).any? {|t| t['name'] == term}
          api.newTerm(:content => {:name => term, :taxonomy => taxonomy})
        end     
      end
    
      def self.ensure_taxonomy_exists(api, term_names)
        term_names.each do |taxonomy|
         unless api.getTaxonomies.any?{|t| t['name'] == taxonomy}
           raise "Unknown taxonomy: " + taxonomy
         end
       end
      end
    
    end
  end
end