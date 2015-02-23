require 'spec_helper'

describe Couponer::Domain::Shop do

  describe 'when creating shops' do

    it 'makes the required change in WordPress' do
      deal_id = 2342
      shop_id = Couponer::Domain::Shop.create(deal_id,
        {
          'addressPostalCode' => SecureRandom.hex,
          'addressStateOrProvince' => SecureRandom.hex,
          'addressStreet1' => SecureRandom.hex,
          'addressStreet2' => SecureRandom.hex,
          'latitude' => 4.3,
          'longitude'=> 4.7,
        })
      api = Couponer::API.new.client
      post = api.getPost(:post_id => shop_id)   
      expect(post).to_not be_nil    
    end    
  end

end

