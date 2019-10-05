class FinancialReason < ApplicationRecord
  has_many :financial_transactions

  validates :title, presence: true,
                    uniqueness: { case_sensitive: false }

  def self.chargeback
    find_by(id: 1)
  end

  def self.morenwm_fee
    find_by(id: 2)
  end
end
