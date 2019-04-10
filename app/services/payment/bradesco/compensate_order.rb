module Payment
  module Bradesco
    class CompensateOrder

      def initialize(order, auth_key)
        @order = order
        @auth_key = auth_key
      end

      def call
        return if current_transaction.blank? || !order.pending_payment? || current_transaction.paid?

        get_order_from_bradesco
        update_bradesco_transaction
        compensate_order
      end

      private

      attr_reader :order, :provider_response, :auth_key

      def get_order_from_bradesco
        @provider_response = GetOrder.call(order, auth_key)
      end

      def update_bradesco_transaction
        current_transaction.provider_response = provider_response
        current_transaction.paid_amount_cents = provider_response['pedidos'].first['valorPago'].to_i
        current_transaction.status            = provider_response['pedidos'].first['status'].to_s
        current_transaction.save!
      end

      def compensate_order
        return unless current_transaction.paid?

        order.boleto!

        PaymentCompensationWorker.perform_async(order.id)
      end

      def current_transaction
        @current_transaction ||= order.current_transaction
      end

    end
  end
end
