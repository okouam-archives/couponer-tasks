require 'method_profiler'
require 'spec_helper'

describe Couponer::Providers::ShopWindow do

  describe 'when finding deals' do

    it 'retrieves all available deals' do
      
      profiler = MethodProfiler.observe(Couponer::Providers::ShopWindow)
      
      provider = Couponer::Providers::ShopWindow.new
      
      provider.on(:error) do |watcher, label, id , ex|
        raise ex 
      end

      provider.deal_limit = 40
      provider.find_deals
      
      puts profiler.report
    end

  end

end

