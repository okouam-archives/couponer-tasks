require 'spec_helper'
require_relative 'helpers'

describe Couponer::Providers::ShopWindow do

  describe 'when finding KGB deals' do

    it 'retrieves all available deals' do
      find_merchant_deals('KGB')
    end

  end

end
