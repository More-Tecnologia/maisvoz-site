# frozen_string_literal: true

module Dashboards
  module Admins
    class IndexPresenter
      def answered_tickets_count
        Ticket.select(:status).answered.count
      end

      def finished_tickets_count
        Ticket.select(:status).finished.count
      end

      def waiting_tickets
        Ticket.waiting
      end

      def waiting_tickets_count
        Ticket.select(:status).waiting.count
      end

      def total_balance
        system_balance + pool_balance
      end

      def pool_balance
        PoolWallet.sum(&:amount)
      end

      def system_balance
        system_balance_orders.sum(&:amount)
      end

      def virtual_balance
        User.find_morenwm_customer_admin.available_balance
      end

      def courses_balance
        OrderItem.includes(:product, order: :payment_transaction).where(product: Product.course, order: Order.paid.currency_balance).sum { |oi| oi.order.payment_transaction.amount }
      end

      def packages_balance
        OrderItem.includes(:product, order: :payment_transaction).where(product: Product.deposit, order: Order.paid.currency_balance).sum { |oi| oi.order.payment_transaction.amount }
      end

      def publicity_balance
        OrderItem.includes(:product, order: :payment_transaction).where(product: Product.publicity, order: Order.paid.currency_balance).sum { |oi| oi.order.payment_transaction.amount }
      end

      def crypto_balance
        OrderItem.includes(:product, order: :payment_transaction).where(product: Product.crypto, order: Order.paid.currency_balance).sum { |oi| oi.order.payment_transaction.amount }
      end

      def free_order_count
        Order.paid.free.count
      end

      private

      def system_balance_orders
        PaymentTransaction.select(:amount).where(order: Order.paid.currency_balance)
      end
    end
  end
end
