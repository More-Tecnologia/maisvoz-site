class FinancialReason < ApplicationRecord
  has_many :financial_transactions

  belongs_to :financial_reason_type

  validates :title, presence: true,
                    uniqueness: { case_sensitive: false }
  scope :bonus, -> { FinancialReason.where(financial_reason_type: FinancialReasonType.bonus) }

  def self.chargeback
    find_by(id: 1)
  end

  def self.morenwm_fee
    find_by(id: 2)
  end

  def self.withdrawal
    find_by(code: 300)
  end

  def self.withdrawal_fee
    find_by(code: 400)
  end
end
