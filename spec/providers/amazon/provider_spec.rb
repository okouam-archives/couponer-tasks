require 'spec_helper'
require 'method_profiler'

LOGIN = 'wwwfootymatte-21'

PASSWORD = '21etwwtafw-0412'

describe Couponer::Providers::Amazon do

  describe 'when parsing deals' do

    it 'processes all available deals' do
        
        profiler = MethodProfiler.observe(Couponer::Providers::Amazon)
      
        provider = Couponer::Providers::Amazon.new
        
        provider.on(:error) do |watcher, deal, ex|
          raise ex 
        end
        
        provider.deal_limit = 40
        provider.find_deals(LOGIN, PASSWORD, 'spec/fixtures/amazon-deals.json.gz')
        
        puts profiler.report
    end

  end

end

