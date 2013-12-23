require 'spec_helper'

describe Affiliate::Gateway do

  describe "when connecting to Affiliate Windows" do

    it "connects successfully" do
      Affiliate::Gateway.new.connect("18ff0b3f7fc8888344c37722b206a232")
    end

  end

  describe "when getting the product list" do

    before(:all) do
      @client = Affiliate::Gateway.new.connect("18ff0b3f7fc8888344c37722b206a232")
    end

    it "gets the product list" do
      products = @client.get_product_list
      expect(products.size).to be > 0
    end

  end

end

