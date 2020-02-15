class FinancialReason < ApplicationRecord
  has_many :financial_transactions

  enum company_moneyflow: [:credit, :debit]

  belongs_to :financial_reason_type
  belongs_to :financial_reason, optional: true

  has_one :chargeback_by_inactivity, class_name: 'FinancialReason',
                                     foreign_key: 'financial_reason_id'

  validates :title, presence: true,
                    uniqueness: { case_sensitive: false }
  validates :code, presence: true,
                   uniqueness: { case_sensitive: false }

  scope :bonus, -> { FinancialReason.where(financial_reason_type: FinancialReasonType.bonus) }
  scope :unilevel, -> { FinancialReason.where(code: ['100', '200', '300', '400']) }
  scope :active, -> { where(active: true) }
  scope :to_morenwm, -> { where(code: ['200', '300', '400', '2800', '2900']) }
  scope :to_customer_admin, -> { where.not(code: '300') }
  scope :to_empreendedor, -> { where.not(code: ['200', '1200', '400']) }

  def is_bonus?
    financial_reason_type.code == '200'
  end

  def withdrawal?
    financial_reason_type.code == '300'
  end

  def credit_reason?
    code == '2800'
  end

  def debit_reason?
    code == '2900'
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

  def self.credit_reason
    @@credit_reason ||= find_by(code: '2800')
  end

  def self.debit_reason
    @@debit_reason ||= find_by(code: '2900')
  end

  def self.support_point_activation_bonus
    @@support_point_activation_bonus ||= find_by(code: '3100')
  end

  def self.residual_bonus
    @@residual_bonus ||= find_by(code: '2600')
  end

  def self.support_point_residual_bonus
    @@support_point_residual_bonus ||= find_by(code: '1400')
  end

  def self.binary_bonus_chargeback_by_daily_excees
    @@binary_bonus_chargeback_by_daily_excees ||= find_by(code: '3300')
  end

  def self.chargeback_by_contract_limit
    @@chargeback_by_contract_limit ||= find_by(code: '3400')
  end

  def self.pool_tranding
    @@pool_tranding ||= find_by(code: '3500')
  end

end
