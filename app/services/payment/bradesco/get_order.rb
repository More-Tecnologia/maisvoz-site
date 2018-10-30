module Payment
  module Bradesco
    class GetOrder < ApplicationService

      DEFAULT_HEADERS = {
        'Content-Type'  => 'application/json; charset=utf8',
        'Accept'        => 'application/json',
        'Authorization' => "Basic #{ENV.fetch('BRADESCO_CRED')}"
      }.freeze

      URL = 'https://meiosdepagamentobradesco.com.br/SPSConsulta/GetOrderById/100007991'.freeze

      def initialize(order, auth_key)
        @order = order
        @auth_key = auth_key
      end

      def call
        res = RestClient.get(url, DEFAULT_HEADERS)
        JSON.parse(res.body)
      end

      private

      attr_reader :order, :auth_key

      def url
        URL + "?token=#{auth_key}&orderId=#{order.id}"
      end

    end
  end
end