require 'spec_helper'

LOGIN = 'wwwfootymatte-21'

PASSWORD = '21etwwtafw-0412'

describe Couponer::Providers::Amazon do

  describe 'when parsing deals' do

    it 'processes all available deals' do
        Couponer::Providers::ShopWindow.parse_deals('spec/fixtures/amazon-deals.json.gz')
    end

  end

end

