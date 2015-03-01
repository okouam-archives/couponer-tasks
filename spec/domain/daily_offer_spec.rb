require 'spec_helper'

describe Couponer::Domain::Post do

  describe 'when creating posts' do

    it 'makes the required change in WordPress' do
      deal_id = Couponer::Domain::Post.create(SecureRandom.hex + "_1", SecureRandom.hex + "_2", nil,
        {
          SecureRandom.hex + "_A" => SecureRandom.hex + "_B",
          SecureRandom.hex + "_C" => SecureRandom.hex + "_D",
          SecureRandom.hex + "_E" => SecureRandom.hex + "_F",
        }
      )
      api = Couponer::API.new.client
      post = api.getPost(:post_id => deal_id)    
      expect(post).to_not be_nil    
    end    
  end

end

