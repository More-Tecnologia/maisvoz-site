class FinancialReport < ApplicationRecord
  POOL_PERCENTAGE = 75
  PROFIT_PERCENTAGE = 25
  PARTNER_PROFIT_PERCENTAGE = 5

  validates_presence_of :order_payment_amount_cents, :pool_amount_cents,
                        :withdrawal_amount_cents, :pool_balance_amount_cents,
                        :profit_amount_cents, :profit_per_partner_amount_cents,
                        :begin_datetime, :end_datetime

  validates_numericality_of :order_payment_amount_cents, :pool_amount_cents,
                            :withdrawal_amount_cents, :pool_balance_amount_cents,
                            :profit_amount_cents, :profit_per_partner_amount_cents

  after_initialize :assign_pool_and_profit_amount_cents

  def self.current_week
    FinancialReport.new(order_payment_amount_cents: current_week_order_payment_amount,
                        withdrawal_amount_cents: current_week_withdrawal_amount)
  end

  private

  def assign_pool_and_profit_amount_cents
    self.pool_amount_cents = order_payment_amount_cents * POOL_PERCENTAGE / 100.0
    self.pool_balance_amount_cents = pool_amount_cents - withdrawal_amount_cents
    self.profit_amount_cents = order_payment_amount_cents * PROFIT_PERCENTAGE / 100.0
    self.profit_per_partner_amount_cents = profit_amount_cents * PARTNER_PROFIT_PERCENTAGE / 100.0
  end

  def self.current_week_order_payment_amount
    FinancialTransaction.to_customer_admin
                        .order_payments
                        .created_at(Date.current.beginning_of_week, Date.current.end_of_week)
                        .sum(:cent_amount) / 1e8
  end

  def self.current_week_withdrawal_amount
    FinancialTransaction.to_customer_admin
                         .withdrawals
                         .created_at(Date.current.beginning_of_week, Date.current.end_of_week)
                         .sum(:cent_amount) / 1e8
  end
end
