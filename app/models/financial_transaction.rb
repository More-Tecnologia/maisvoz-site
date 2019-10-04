class FinancialTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :spreader, class_name: 'User'
  belongs_to :financial_reason
  belongs_to :order, optional: true
  belongs_to :financial_transaction, optional: true

  has_one :chargeback, class_name: 'FinancialTransaction',
                       foreign_key: 'financial_transaction_id'

  enum moneyflow: [:credit, :debit]

  validates :cent_amount, presence: true,
                          numericality: { only_integer: true }

  before_validation :turn_cent_amount_positive, if: :credit?
  before_validation :turn_cent_amount_negative, if: :debit?

  def chargeback!
    create_chargeback(user: user,
                      spreader: spreader,
                      financial_reason: financial_reason,
                      order: order,
                      cent_amount: cent_amount,
                      moneyflow: invert_money_flow)
  end

  private

  def invert_money_flow
    FinancialTransaction.moneyflows.keys.detect { |e| e != moneyflow }
  end

  def turn_cent_amount_positive
    self[:cent_amount] = cent_amount.abs if cent_amount&.integer?
  end

  def turn_cent_amount_negative
    self[:cent_amount] = -(cent_amount.abs) if cent_amount&.integer?
  end
end
