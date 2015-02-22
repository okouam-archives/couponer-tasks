require 'spec_helper'

describe Couponer::Domain::TermTaxonomy do

  describe 'when adding term taxonomies' do

    it 'creates or fetches the term in WordPress' do
      Couponer::API.clear_taxonomies 
      term_taxonomy = Couponer::Domain::TermTaxonomy.create('london', 'category')
      expect(term_taxonomy).not_to be_nil 
      expect(term_taxonomy['name']).to eq('london')
      expect(term_taxonomy['taxonomy']).to eq('category')
    end

  end

end

