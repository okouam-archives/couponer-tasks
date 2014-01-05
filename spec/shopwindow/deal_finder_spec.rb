require 'spec_helper'

describe ShopWindow::DealFinder do

  before(:each) do
    init_wordpress
  end

  describe 'when finding deals' do

    it 'retrieves all available deals' do
      deal_finder = ShopWindow::DealFinder.new
      deal_finder.find_deals()
    end

  end

end

