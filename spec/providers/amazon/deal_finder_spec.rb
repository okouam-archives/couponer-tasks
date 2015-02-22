require 'spec_helper'

LOGIN = 'wwwfootymatte-21'

PASSWORD = '21etwwtafw-0412'

describe Amazon::DealFinder do

  before(:each) do
    init_wordpress
  end

  describe 'when parsing deals' do

    it 'processes all available deals' do
      Amazon::DealFinder.parse_deals('spec/fixtures/amazon-deals.json.gz')
    end

  end

end

