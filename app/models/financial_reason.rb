class FinancialReason < ApplicationRecord
  has_many :financial_transactions

  validates :title, presence: true,
                    uniqueness: { case_sensitive: false }
end
