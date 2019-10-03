class FinancialTransaction < ApplicationRecord
  belongs_to :user
  belongs_to :spreader, class_name: 'User'
  belongs_to :financial_reason

  enum moneyflow: [:credit, :debit]

  validates :cent_amount, presence: true,
                          numericality: { only_integer: true }
end
