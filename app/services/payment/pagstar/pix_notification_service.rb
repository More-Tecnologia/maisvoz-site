# frozen_string_literal: true

module Payment
  module Pagstar
    class PixNotificationService < ApplicationService
      def call
        @payment_transaction.paid!
        @payment_transaction.order.pix!
        PaymentCompensationWorker.perform_async(@payment_transaction.order.id)
      rescue StandardError => error
        register_notification_error(error.message)
        raise error.message
      end

      private

      def initialize(params)
        @transaction_id = params[:transaction_id]
        @payment_transaction = find_payment_transaction
      end

      def find_payment_transaction
        PaymentTransaction.started
                          .includes(order: [:user])
                          .where(transaction_id: @transaction_id)
                          .first
      end

      def register_notification_error(error_message)
        payment_transaction.update(:provider_response, error_message)
      end
    end
  end
end
