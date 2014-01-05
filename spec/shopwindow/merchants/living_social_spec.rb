require 'spec_helper'

describe ShopWindow::Handler do

  before(:all) do
    @file = File.open('spec/fixtures/shopwindow/living_social.xml', 'rb')
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
      processor.process(@contents, @logger, 'Living Social')
    end

  end

end

