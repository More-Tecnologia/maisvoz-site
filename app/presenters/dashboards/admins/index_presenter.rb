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
        PoolWallet.sum(&:cent_amount)
      end

      def system_balance
        incoming_balance - paid_withdraws_balance - expenses_balance
      end

      def incoming_balance
        system_balance_orders.sum(&:amount)
      end

      def virtual_balance
        User.find_morenwm_customer_admin.available_balance
      end

      def expenses_balance
        FinancialTransaction.where(financial_reason: FinancialReason.expense).sum(&:cent_amount)
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

      def btc_order_count
        Order.paid.btc.count
      end

      def admin_order_count
        Order.paid.admin.count
      end

      def admin_nb_order_count
        Order.paid.admin_nb.count
      end

      def paid_withdraws_count
        Withdrawal.approved.count
      end

      def pending_withdraws_count
        Withdrawal.pending.count
      end

      def waiting_withdraws_count
        Withdrawal.waiting.count
      end

      def rejected_withdraws_count
        Withdrawal.refused.count
      end

      def canceled_withdraws_count
        Withdrawal.canceled.count
      end

      def paid_withdraws_balance
        Withdrawal.select(:crypto_amount).approved.sum(&:crypto_amount)
      end

      private

      def system_balance_orders
        PaymentTransaction.select(:amount).where(order: Order.paid.currency_balance)
      end
    end
  end
end
