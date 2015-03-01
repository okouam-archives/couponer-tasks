require 'spec_helper'
require_relative 'helpers'

describe Couponer::Providers::ShopWindow do

  describe 'when finding Groupon deals' do

    it 'retrieves all available deals' do
      find_merchant_deals('Groupon')
    end

  end

end
