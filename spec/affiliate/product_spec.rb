require 'spec_helper'

describe Affiliate::Product do

  describe("when retrieving arbitrary properties") do

    it "works" do
      product = Affiliate::Product.new({'s_merchant_thumb_url' => "XXX"})
      expect(product.merchant_thumb_url).to be == "XXX"
    end

  end

end
