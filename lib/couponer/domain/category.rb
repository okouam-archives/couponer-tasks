module Couponer
  module Domain 
    class Category

      def self.create(key)
        TermTaxonomy.create(key, 'category')
      end

    end
  end
end

