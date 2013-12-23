module Affiliate

  class Product

    def initialize(attrs)
      @attrs = []
      attrs.each do |key, value|
        @attrs.push({method: key[2..-1], type: key[0], value: value})
      end
    end

    def method_missing(name)
      property = @attrs.select do |x|
        x[:method] == name.to_s
      end
      property[0][:value].send('to_' + property[0][:type])
    end

  end

end

