class FinancialTransaction < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  belongs_to :spreader, class_name: 'User'
  belongs_to :financial_reason
  belongs_to :order, optional: true
  belongs_to :financial_transaction, optional: true

  has_one :chargeback, class_name: 'FinancialTransaction',
                       foreign_key: 'financial_transaction_id'

  enum moneyflow: [:credit, :debit]

  scope :chargeback, -> { where.not(financial_transaction: nil) }
  scope :not_chargeback, -> { where(financial_transaction: nil) }
  scope :includes_associations, -> { includes(:user, :spreader, :financial_reason,
                                             :order, :financial_transaction, :chargeback) }
  scope :by_user, ->(user) { includes_associations.where(user: user) }
  scope :financial_reason_bonus,
    -> { includes_associations.where(financial_reason: FinancialReason.bonus) }

  validates :cent_amount, presence: true,
                          numericality: { only_integer: true }

  def chargeback!
    create_chargeback(user: User.find_morenwm_customer_user,
                      spreader: user,
                      financial_reason: FinancialReason.chargeback,
                      order: order,
                      cent_amount: cent_amount,
                      moneyflow: invert_money_flow)
  end

  def chargeback?
    financial_transaction
  end

  private

  def invert_money_flow
    FinancialTransaction.moneyflows.keys.detect { |e| e != moneyflow }
  end
end
