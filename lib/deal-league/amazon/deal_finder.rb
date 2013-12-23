require 'vacuum'

module Amazon

  class DealFinder

    def initialize(key, secret, tag)
      @client = Vacuum.new('GB')
      @client.configure(aws_access_key_id: key, aws_secret_access_key: secret, associate_tag: tag)
    end

    def find_deals
      params = {
          'SearchIndex' => 'Books',
          'Keywords'    => 'Architecture'
      }
      items = @client.item_search(params)
      debugger;
      x = 1
    end

  end

end
