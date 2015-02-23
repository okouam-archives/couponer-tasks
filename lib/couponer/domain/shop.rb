module Couponer
  module Domain 
    class Shop

      def self.create(deal_id, location)
        Couponer::Domain::Post.create(SecureRandom.hex, SecureRandom.hex, 'shop', {
          'addressPostalCode' => location['addressPostalCode'],
          'addressStateOrProvince' => location['addressStateOrProvince'],
          'addressStreet1' => location['addressStreet1'],
          'addressStreet2' => location['addressStreet2'],
          'latitude' => location['latitude'],
          'longitude'=> location['longitude'],
          'deal' => deal_id
        })
      end

    end
  end
end

