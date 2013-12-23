require 'spec_helper'

ACCESS_KEY = 'AKIAIO5XYJNLYLYK72MA'

SECRET = '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'

TAG_ID = 'wwwfootymatte-21'

describe Amazon::DealFinder do

  describe "when finding deals" do

    it "retrieves all available deals" do
      deal_finder = Amazon::DealFinder.new(ACCESS_KEY, SECRET, TAG_ID)
      deal_finder.find_deals
    end

  end

end

