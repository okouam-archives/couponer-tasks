require "sequel"

module Affiliate

  class Repository

    def initialize(connection_string)
      @db = Sequel.mysql(connection_string)
    end

    def save_products(products)

      unless @db.table_exists?(:products)
        @db.create_table :products do
          primary_key :id
          String :name
          Float :price
        end
      end

      dataset = @db[:products]

      products.each do |product|
        dataset.insert()
      end

    end

  end

end

