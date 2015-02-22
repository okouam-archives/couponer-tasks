module Couponer
  module Domain
    class TermTaxonomy
  
      @terms = {}
      @term_taxonomies = {}
    
      def self.create(key, label)
        if @terms.has_key?(key)
          term_id = @terms[key].term_id
          taxonomy = @term_taxonomies[term_id]
        else
          term = WPDB::Term.find(:name => key)
          if term
            taxonomy = WPDB::TermTaxonomy.find(:term_id => term.term_id, :taxonomy => label)
          else
            term = WPDB::Term.create(:name => key) unless term
            taxonomy = WPDB::TermTaxonomy.create(:term_id => term.term_id, :taxonomy => label)
          end
          @terms[key] = term
          @term_taxonomies[term.term_id] = taxonomy
        end
      end
    
    end
  end
end