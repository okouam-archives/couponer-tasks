require 'spec_helper'

describe Couponer::Domain::TermTaxonomy do

  describe 'when assigning deals to terms' do

    it 'makes the required change in WordPress for a single term' do
      daily_offer_id = Couponer::Domain::DailyOffer.create(
        SecureRandom.hex + "_TITLE", 
        SecureRandom.hex + "_DESCRIPTION",
        nil, 
        {
        'product' => [SecureRandom.hex + "_A", SecureRandom.hex + "_B"]
      })
      api = Couponer::API.new.client
      post = api.getPost(:post_id => daily_offer_id)        
      expect(post).to_not be_nil
    end    

    it 'makes the required change in WordPress for a multiple terms' do
      deal_id = Couponer::Domain::DailyOffer.create(SecureRandom.hex + "_1", SecureRandom.hex + "_2")
      Couponer::Domain::TermTaxonomy.assign(deal_id, {
        'product' => [SecureRandom.hex + "_A", SecureRandom.hex + "_B"],
        'geography' => [SecureRandom.hex + "_C"]
      })
      api = Couponer::API.new.client
      post = api.getPost(:post_id => deal_id)  
      expect(post).to_not be_nil      
    end    

  end

end

