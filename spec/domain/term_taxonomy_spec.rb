require 'spec_helper'

describe Couponer::Domain::TermTaxonomy do

  describe 'when assigning deals to taxonomies' do

    it 'makes the required change in WordPress for a single taxonomy' do
      deal_id = Couponer::Domain::Post.create(SecureRandom.hex + "_1", SecureRandom.hex + "_2")
      Couponer::Domain::TermTaxonomy.assign(deal_id, {
        'category' => [SecureRandom.hex + "_A", SecureRandom.hex + "_B"]
      })
      api = Couponer::API.new.client
      post = api.getPost(:post_id => deal_id)        
      expect(post).to_not be_nil
    end    

    it 'makes the required change in WordPress for a multiple taxonomies' do
      deal_id = Couponer::Domain::Post.create(SecureRandom.hex + "_1", SecureRandom.hex + "_2")
      Couponer::Domain::TermTaxonomy.assign(deal_id, {
        'category' => [SecureRandom.hex + "_A", SecureRandom.hex + "_B"],
        'geography' => [SecureRandom.hex + "_C"]
      })
      api = Couponer::API.new.client
      post = api.getPost(:post_id => deal_id)  
      expect(post).to_not be_nil      
    end    

  end

end

