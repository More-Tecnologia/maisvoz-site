class FinancialReason < ApplicationRecord
  has_many :financial_transactions

  belongs_to :financial_reason_type

  validates :title, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :code, presence: true,
                   uniqueness: { case_sensitive: false }

  scope :bonus, -> { FinancialReason.where(financial_reason_type: FinancialReasonType.bonus) }
  scope :unilevel, -> { FinancialReason.where(code: ['100', '200', '300', '400']) }

  def is_bonus?
    financial_reason_type.code == '200'
  end

  def self.chargeback
    find_by(code: '100')
  end

  def self.morenwm_fee
    find_by(code: '200')
  end

  def self.withdrawal
    find_by(code: '300')
  end

  def self.withdrawal_fee
    find_by(code: '400')
  end

  def self.binary_bonus
    find_by(code: '500')
  end

  def self.chargeback_by_inactivity
    find_by(code: '600')
  end

  def self.chargeback_excess_monthly
    find_by(code: '700')
  end

  def self.chargeback_excess_weekly
    find_by(code: '800')
  end

  def self.career_trail_excess_bonus
    find_by(code: '900')
  end

  def self.order_payment
    find_by(code: '1100')
  end

end
