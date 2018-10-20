module Payment
  module Bradesco
    class CompensateOrder

      def initialize(order)
        @order = order
      end

      def call
        get_bradesco_auth_key
        get_order_from_bradesco
        update_bradesco_transaction
        compensate_order
      end

      private

      attr_reader :order, :provider_response, :auth_key

      def get_bradesco_auth_key
        @auth_key = GetAuthKey.call
      end

      def get_order_from_bradesco
        @provider_response = GetOrder.call(order, auth_key)
      end

      def update_bradesco_transaction
        current_transaction.provider_response = provider_response
        current_transaction.paid_amount_cents = provider_response['pedidos'].first['valorPago'].to_i
        current_transaction.status            = provider_response['pedidos'].first['status']
        current_transaction.save!
      end

      def compensate_order
        return unless current_transaction.paid?

        PaymentCompensationWorker.perform_async(order.id)
      end

      def current_transaction
        @current_transaction ||= order.current_transaction
      end

    end
  end
end