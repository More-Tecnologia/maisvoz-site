class FinancialTransaction < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  belongs_to :spreader, class_name: 'User', optional: true
  belongs_to :financial_reason, optional: true
  belongs_to :order, optional: true
  belongs_to :financial_transaction, optional: true
  belongs_to :withdrawal, optional: true

  has_one :chargeback, class_name: 'FinancialTransaction',
                       foreign_key: 'financial_transaction_id'

  enum moneyflow: [:credit, :debit]

  monetize :cent_amount, as: :amount_cents

  scope :chargeback, -> { where.not(financial_transaction: nil) }
  scope :not_chargeback, -> { where(financial_transaction: nil) }
  scope :includes_associations, -> { includes(:user, :spreader, :financial_reason,
                                             :order, :financial_transaction, :chargeback) }
  scope :by_user, ->(user) { includes_associations.where(user: user) }
  scope :financial_reason_bonus,
    -> { includes_associations.where(financial_reason: FinancialReason.bonus) }

  validates :cent_amount, presence: true,
                          numericality: { only_integer: true }

  validates :financial_reason, presence: true,
                               unless: :is_note_present?

  def chargeback!
    create_chargeback!(user: User.find_morenwm_customer_user,
                       spreader: user,
                       financial_reason: FinancialReason.chargeback,
                       order: order,
                       cent_amount: cent_amount,
                       moneyflow: invert_money_flow)
  end

  def chargeback?
    financial_transaction
  end

  def chargeback_binary_score!(financial_reason, amount)
    create_chargeback!(user: user,
                       financial_reason: financial_reason,
                       cent_amount: amount.to_i,
                       moneyflow: invert_money_flow)
  end

  def chargeback_by_inactivity!
    chargeback_binary_score!(FinancialReason.chargeback_by_inactivity, cent_amount)
  end

  def chargeback_excess_monthly!(amount)
    chargeback_binary_score!(FinancialReason.chargeback_excess_monthly, amount)
  end

  def chargeback_excess_weekly!(amount)
    chargeback_binary_score!(FinancialReason.chargeback_excess_weekly, amount)
  end

  private

  def invert_money_flow
    FinancialTransaction.moneyflows.keys.detect { |e| e != moneyflow }
  end

  def is_note_present?
    note.present?
  end
end
