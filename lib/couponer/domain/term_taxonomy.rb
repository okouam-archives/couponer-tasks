require 'awesome_print'

module Couponer
  module Domain
    class TermTaxonomy
   
      def self.assign(deal_id, terms, taxonomy)
        api = Couponer::API.new.client
        self.ensure_taxonomy_exists(api, taxonomy)
        self.ensure_terms_exist(api, terms, taxonomy)
        api.editPost(:post_id => deal_id, :content => {:terms_names => {"#{taxonomy}" => [terms]}})
      end
   
      private
      
      def self.ensure_terms_exist(api, terms, taxonomy)
        terms.each do |term|
          ensure_term_exists(api, term, taxonomy)   
        end
      end
      
      def ensure_term_exists(api, term, taxonomy)
        unless api.getTerms(:taxonomy => taxonomy).any? {|t| t['name'] == term}
          api.newTerm(:content => {:name => term, :taxonomy => taxonomy})
        end     
      end
    
      def self.check_taxonomy_exists(api, taxonomy)
         unless api.getTaxonomies.any?{|t| t['name'] == taxonomy}
           raise "Unknown taxonomy: " . taxonomy
         end
      end
    
    end
  end
end