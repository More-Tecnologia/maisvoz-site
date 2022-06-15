# frozen_string_literal: true

module Webhooks
  module Pagstar
    class PixService < ApplicationService
      if ActiveModel::Type::Boolean.new.cast(ENV['PAGSTAR_ACTIVE'])
        ENDPOINT = "#{ENV['PAGSTAR_API_URL']}/wallet/partner/transactions/generate-anonymous-pix".freeze
        TENANT_ID = ENV['PAGSTAR_TENANT_ID'].freeze
      end

      def initialize(params)
        @order = params[:order]
        @value = (@order.total_cents * ENV['BRL_USD_FACTOR'].to_i) / 100
      end

      private

      def call
        generate_pix_transaction
      end

      def generate_pix_transaction
        response = HTTParty.post(ENDPOINT, headers: headers, body: params)

        raise (response['message'].presence || response.code.to_s) unless response.success?

        response.parsed_response['data'].merge(value: @value)
      end

      def access_token
        GetAccessTokenService.call
      end

      def headers
        {
          'Authorization' => "Bearer #{access_token}",
          'Content-Type' => 'application/json'
        }
      end

      def params
        {
          value: @value,
          email: @order.user.email,
          name: (@order.user.name.presence || @order.user.username),
          document: @order.user.document_cpf,
          tenant_id: TENANT_ID
        }.to_json
      end
    end
  end
end
