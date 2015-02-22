require 'spec_helper'

describe ShopWindow::Handler do

  before(:all) do
    @file = File.open('spec/fixtures/shopwindow/mighty_deals.xml', 'rb')
    @contents = @file.read
    @logger = Logger.new(STDOUT)
  end

  after(:all) do
    @file.close
  end

  before(:each) do
    init_wordpress
  end

  describe 'when processing deals' do

    it 'handles all deals found in the feed' do
      processor = ShopWindow::Handler.new
      processor.process(@contents, @logger, 'Mighty Deals').should == 52
    end

  end

end

