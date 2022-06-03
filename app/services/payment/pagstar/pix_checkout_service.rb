# frozen_string_literal: true

module Payment
  module Pagstar
    class PixCheckoutService < ApplicationService
      def call
        transaction = nil
        ActiveRecord::Base.transaction do
          checkout = pix_transaction_request
          transaction = payment_transaction(checkout)
          @order.update!(status: :pending_payment, payment_type: :pix)
        end
        transaction
      end

      private

      def initialize(params)
        @order = params[:order]
      end

      def pix_transaction_request
        Webhooks::Pagstar::PixService.call(order: @order)
      end

      def payment_transaction(response)
        @order.create_payment_transaction!(amount: response['value'],
                                           transaction_id: response['external_reference'],
                                           wallet_address: response['pix_key'],
                                           qr_code_url: response['qr_code_url'],
                                           provider_response: response)
      end
    end
  end
end
