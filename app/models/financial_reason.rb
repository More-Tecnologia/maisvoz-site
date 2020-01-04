class FinancialReason < ApplicationRecord
  has_many :financial_transactions

  belongs_to :financial_reason_type
  belongs_to :financial_reason, optional: true

  has_one :chargeback_by_inactivity, class_name: 'FinancialReason'

  validates :title, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :code, presence: true,
                   uniqueness: { case_sensitive: false }

  scope :bonus, -> { FinancialReason.where(financial_reason_type: FinancialReasonType.bonus) }
  scope :unilevel, -> { FinancialReason.where(code: ['100', '200', '300', '400']) }
  scope :active, -> { where(active: true) }

  def is_bonus?
    financial_reason_type.code == '200'
  end

  def withdrawal?
    financial_reason_type.code == '300'
  end

  def self.chargeback
    @@chargeback ||= find_by(code: '100')
  end

  def self.morenwm_fee
    @@more_fee ||= find_by(code: '200')
  end

  def self.withdrawal
    @@withdrawal ||= find_by(code: '300')
  end

  def self.withdrawal_fee
    @@withdrawal_fee ||= find_by(code: '400')
  end

  def self.binary_bonus
    @@binary_bonus ||= find_by(code: '500')
  end

  def self.chargeback_by_inactivity
    @@chargeback_by_inactivity ||= find_by(code: '600')
  end

  def self.chargeback_excess_monthly
    @@chargeback_excess_monthly ||= find_by(code: '700')
  end

  def self.chargeback_excess_weekly
    @@chargeback_excess_weekly ||= find_by(code: '800')
  end

  def self.career_trail_excess_bonus
    @@career_trail_excess_bonus ||= find_by(code: '900')
  end

  def self.indication_bonus
    @@indication_bonus ||= find_by(code: '1000')
  end

  def self.yield_bonus
    @@yield_bonus = find_by(code: '1100')
  end

  def self.order_payment
    @@order_payment ||= find_by(code: '1200')
  end

  def self.chargeback_by_unqualification
    @@chargeback_by_unqualification ||= find_by(code: '1300')
  end

end
