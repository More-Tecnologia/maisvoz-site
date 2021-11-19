class BonusContract < ApplicationRecord
  include Hashid::Rails

  RENTABILITY_DAYS_COUNT = 365

  belongs_to :order
  belongs_to :user

  has_many :bonus_contract_items
  has_many :financial_transactions

  validates :cent_amount, presence: true,
                          numericality: { greater_than_or_equal_to: 0 }
  validates :remaining_balance, presence: true,
                                numericality: { greater_than_or_equal_to: 0 }
  validates :received_balance, presence: true,
                               numericality: { greater_than_or_equal_to: 0 }

  scope :active, -> { where('bonus_contracts.expire_at > ? AND bonus_contracts.paid_at IS NULL', DateTime.current) }
  scope :inactive, -> { where('bonus_contracts.expire_at <= ? OR bonus_contracts.paid_at IS NOT NULL', DateTime.current) }
  scope :loans, -> { active.with_active_loan }
  scope :yield_contracts, -> { where(loan: false) }
  scope :enabled_bonification, -> { where(enabled_bonification: true) }

  delegate :order_items, to: :order

  def active?
    return false if paid_at || expire_at < DateTime.current
    return true
  end

  def cent_amount
    self[:cent_amount] / 1e2.to_f if self[:cent_amount]
  end

  def cent_amount=(amount)
    self[:cent_amount] = (amount * 1e2).to_i
  end

  def max_gains?
    task_gains >= max_task_gains
  end

  def max_contract_gains?
    free_product? && task_gains >= 25
  end

  def maxed_out_gains
    task_gains - 25
  end

  def maxed_out_gains?
    maxed_out_gains.positive?
  end

  def net_task_gains
    task_gains - financial_transactions.where(moneyflow: :debit, financial_reason: FinancialReason.withdrawal)
                                       .sum(&:cent_amount)
  end

  def task_gains
    gross_task_gains - financial_transactions.where(moneyflow: :debit)
                                             .where.not(financial_reason: FinancialReason.withdrawal)
                                             .sum(&:cent_amount)
  end

  def gross_task_gains
    financial_transactions.includes(:financial_reason)
                          .where(financial_reason: task_reason)
                          .sum(&:cent_amount)
  end

  def task_reason
    [FinancialReason.free_task_performed, FinancialReason.yield_bonus,
     FinancialReason.direct_commission_bonus, FinancialReason.indirect_referral_bonus,
     FinancialReason.matching_bonus]
  end

  def free_product?
    price.zero?
  end

  def price
    order_items.last.product.price_cents
  end

  def max_task_gains
    free_product? ? 7.5 : (price * 2 / 100)
  end

  def remaining_balance
    self[:remaining_balance] / 1e2.to_f if self[:remaining_balance]
  end

  def remaining_balance=(amount)
    self[:remaining_balance] = (amount * 1e2).to_i
  end

  def received_balance
    self[:received_balance] / 1e2.to_f if self[:received_balance]
  end

  def received_balance=(amount)
    self[:received_balance] = (amount * 1e2).to_i
  end

  def received?
    cent_amount.round(2) == received_balance.round(2) &&
    remaining_balance.round(2) == 0
  end

  def normalize_balances_from_items!
    received = bonus_contract_items.sum(&:cent_amount)
    remaining = cent_amount - received

    update!(received_balance: received,
            remaining_balance: remaining)
  end
end
