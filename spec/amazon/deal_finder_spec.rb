require 'spec_helper'

LOGIN = 'wwwfootymatte-21'

PASSWORD = '21etwwtafw-0412'

describe Amazon::DealFinder do

  describe "when finding deals" do

    it "retrieves all available deals" do
      deal_finder = Amazon::DealFinder.new
      deal_finder.find_deals(LOGIN, PASSWORD, "amazon-deals.json.gz")
    end

  end

end

