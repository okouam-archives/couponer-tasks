require 'savon'

module Affiliate

  API_URL = "http://v3.core.com.productserve.com/ProductServeService.wsdl"

  class Gateway

    def connect(api_key)
      @client = Savon.client(
          :wsdl => API_URL,
          :soap_header => {'UserAuthentication' => {'sApiKey' => api_key}}
      )
      self
    end

    def get_product_list
      response = @client.call(:get_product_list)
      response.hash[:envelope][:body][:get_product_list_response][:o_product].map do |values|
        Product.new values
      end
    end

  end

end
