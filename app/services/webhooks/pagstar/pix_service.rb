# frozen_string_literal: true

module Webhooks
  module Pagstar
    class PixService < ApplicationService
      CALLBACK = ENV['PAGSTAR_CALLBACK'].freeze
      ENDPOINT = (ENV['PAGSTAR_API_URL'] + '/wallet/partner/transactions/generate-anonymous-pix').freeze
      TENANT_ID = ENV['PAGSTAR_TENANT_ID']

      def initialize(params)
        @order = params[:order]
      end

      private

      def call
        generate_pix_transaction
      end

      def generate_pix_transaction
        response = HTTParty.post(ENDPOINT, headers: headers, body: params)
  
        raise response.code.to_s unless response.success?
  
        response.parsed_response['data']
      end

      def access_token
        GetAccessTokenService.call
      end

      def headers
        {
          'Authorization' =>  'Bearer ' + access_token,
          'Content-Type' => 'application/json'
        }
      end

      def params
        {
          value: (@order.total_cents * ENV['REAL_USD_FACTOR'].to_i) / 100,
          email: @order.user.email,
          name: @order.user.username,
          document: @order.user.document_cpf,
          tenant_id: TENANT_ID
        }
      end
    end
  end
end
