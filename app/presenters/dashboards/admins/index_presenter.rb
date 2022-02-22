# frozen_string_literal: true

module Dashboards
  module Admins
    class IndexPresenter
      def answered_tickets_count
        Ticket.select(:status).answered.count
      end

      def admin_order_count
        Order.paid.admin.count
      end

      def admin_nb_order_count
        Order.paid.admin_nb.count
      end

      def btc_order_count
        Order.paid.btc.count
      end

      def canceled_withdraws_count
        Withdrawal.canceled.count
      end

      def courses_balance
        OrderItem.includes(order: :payment_transaction).where(product: Product.course, order: Order.paid.currency_balance).sum { |oi| oi.order.payment_transaction.amount }
      end

      def courses_balance_dollar
        to_dollar(courses_balance)
      end

      def crypto_balance
        OrderItem.includes(order: :payment_transaction).where(product: Product.crypto, order: Order.paid.currency_balance).sum { |oi| oi.order.payment_transaction.amount }
      end

      def crypto_balance_dollar
        to_dollar(crypto_balance)
      end

      def expenses_balance
        expenses_balance_dollar * btc_rate
      end

      def expenses_balance_dollar
        FinancialTransaction.where(financial_reason: FinancialReason.expense).sum(&:cent_amount)
      end

      def expenses_balance_last_30_days
        reverse_hash(
        last_30_days_hash.merge(
        FinancialTransaction.where(financial_reason: FinancialReason.expense)
                            .created_after(30)
                            .group_by { |transaction| transaction.created_at.to_date }
                            .transform_values { |v| v.sum(&:cent_amount) * btc_rate }
                            ) { |key, old_value, new_value| old_value + new_value })
                            .values
      end

      def finished_tickets_count
        Ticket.select(:status).finished.count
      end

      def free_order_count
        Order.paid.free.count
      end

      def incoming_balance
        system_balance_orders.sum(&:amount)
      end

      def incoming_balance_dollar
        to_dollar(system_balance_orders.sum(&:amount))
      end

      def incoming_balance_last_30_days
        reverse_hash(
        last_30_days_hash.merge(
        system_balance_orders_last_30_days.group_by { |order| order.created_at.to_date }
                                          .transform_values { |v| v.sum(&:total_cents)}
                                          ) { |key, old_value, new_value| old_value + new_value })
                                          .values
      end

      def last_30_days_hash
        today = Date.today
        Hash[
          (0..30).map do |index|
            [(today - index), 0]
          end
        ]
      end

      def last_30_days_keys
        last_30_days_hash.keys.reverse.map { |k| k.strftime("%d %m") }
      end

      def pool_balance
        @pool_balance ||= PoolWallet.sum(&:cent_amount)
      end

      def pool_balance_dollar
        to_dollar(pool_balance)
      end

      def packages_balance
        OrderItem.includes(order: :payment_transaction).where(product: Product.deposit, order: Order.paid.currency_balance).sum { |oi| oi.order.payment_transaction.amount }
      end

      def packages_balance_dollar
        to_dollar(packages_balance)
      end

      def paid_withdraws_count
        Withdrawal.approved.count
      end

      def paid_withdraws_balance
        Withdrawal.select(:crypto_amount).approved.sum(&:crypto_amount)
      end

      def paid_withdraws_balance_dollar
        to_dollar(paid_withdraws_balance)
      end

      def paid_withdraws_balance_last_30_days
        reverse_hash(
        last_30_days_hash.merge(
        Withdrawal.select(:crypto_amount, :created_at)
                  .approved
                  .created_after(30)
                  .group_by { |withdrawal| withdrawal.created_at.to_date }
                  .transform_values { |v| v.sum(&:crypto_amount) }
                  ) { |key, old_value, new_value| old_value + new_value })
                  .values

      end

      def pending_withdraws_count
        Withdrawal.pending.count
      end

      def pool_wallets
        PoolWallet.all
      end

      def publicity_balance
        OrderItem.includes(order: :payment_transaction).where(product: Product.publicity, order: Order.paid.currency_balance).sum { |oi| oi.order.payment_transaction.amount }
      end

      def publicity_balance_dollar
        to_dollar(publicity_balance)
      end

      def rejected_withdraws_count
        Withdrawal.refused.count
      end

      def reverse_hash(hash)
        Hash[hash.to_a.reverse]
      end

      def system_balance
        incoming_balance - paid_withdraws_balance - expenses_balance
      end

      def system_balance_dollar
        to_dollar(system_balance)
      end

      def to_dollar(amount)
        amount / btc_rate
      end

      def total_balance
        system_balance + pool_balance
      end

      def total_balance_dollar
        to_dollar(total_balance)
      end

      def virtual_balance
        User.find_morenwm_customer_admin.available_balance
      end

      def virtual_balance_btc
        User.find_morenwm_customer_admin.available_balance * btc_rate
      end

      def waiting_withdraws_count
        Withdrawal.waiting.count
      end

      def waiting_tickets
        Ticket.waiting
      end

      def waiting_tickets_count
        Ticket.select(:status).waiting.count
      end

      private

      def btc_rate
        rates[:BTC]
      end

      def rates
        @rates ||= Webhooks::Coinbase::DollarExchangeRates.call
      end

      def system_balance_orders
        PaymentTransaction.select(:amount).where(order: Order.paid.currency_balance)
      end

      def system_balance_orders_last_30_days
        Order.select(:id, :created_at, :total_cents).paid.currency_balance.created_after(30)
      end
    end
  end
end
