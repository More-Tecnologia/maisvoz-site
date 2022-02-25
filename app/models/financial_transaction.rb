class FinancialTransaction < ApplicationRecord
  include Hashid::Rails

  belongs_to :user
  belongs_to :spreader, class_name: 'User', optional: true
  belongs_to :financial_reason, optional: true
  belongs_to :order, optional: true
  belongs_to :financial_transaction, optional: true
  belongs_to :withdrawal, optional: true
  belongs_to :bonus_contract, optional: true
  belongs_to :source_financial_transaction, optional: true,
                                            class_name: 'FinancialTransaction'

  has_one :chargeback, class_name: 'FinancialTransaction',
                       foreign_key: 'financial_transaction_id'
  has_one :bonus_contract_item, dependent: :delete
  has_many :children_financial_transactions, class_name: 'FinancialTransaction',
                                             foreign_key: 'source_financial_transaction_id'

  enum moneyflow: [:credit, :debit]

  monetize :cent_amount, as: :amount_cents

  scope :chargeback, -> { where.not(financial_transaction: nil) }
  scope :not_chargeback, -> { where(financial_transaction: nil) }
  scope :includes_associations, -> { includes(:user, :spreader, :financial_reason,
                                             :order, :financial_transaction, :chargeback) }
  scope :by_user, ->(user) { where(user: user) }
  scope :financial_reason_bonus,
    -> { includes_associations.where(financial_reason: FinancialReason.bonus) }
  scope :company_credit, -> { joins(:financial_reason).merge(FinancialReason.credit) }
  scope :company_debit, -> { joins(:financial_reason).merge(FinancialReason.debit) }
  scope :backward_at, ->(date) { where('financial_transactions.created_at <= ?', date) }
  scope :not_bonus, -> { where.not(financial_reason: FinancialReason.bonus) }
  scope :bonus, -> { includes(:financial_reason).where(financial_reason: FinancialReason.bonus)}
  scope :with_active_bonus, -> { bonus.where(financial_reasons: { active: true }) }
  scope :to_morenwm, -> { joins(:financial_reason).merge(FinancialReason.to_morenwm) }
  scope :to_customer_admin, -> { joins(:financial_reason).merge(FinancialReason.to_customer_admin) }
  scope :to_empreendedor, -> { joins(:financial_reason).merge(FinancialReason.to_empreendedor) }
  scope :chargebacks_from, ->(user) { where(spreader: user, user: User.find_morenwm_customer_admin) }
  scope :by_current_user, ->(user) { where(user: user).or(FinancialTransaction.chargebacks_from(user)) }
  scope :at_last_month,
    -> { where(created_at: (1.month.ago.beginning_of_month..1.month.ago.end_of_month)) }
  scope :from_id, ->(id) { id ? where('financial_transactions.id > ?', id).order(:id) : order(:id) }
  scope :by_bonus, ->(bonus) { where(financial_reason: bonus) }
  scope :morenwm_moneyflow_credit, -> { where(financial_reason: FinancialReason.morenwm_moneyflow_credit) }
  scope :morenwm_moneyflow_debit, -> { where(financial_reason: FinancialReason.morenwm_moneyflow_debit) }
  scope :yield_bonus, -> { where(financial_reason: FinancialReason.yield_bonus) }
  scope :order_payments, -> { where(financial_reason: [FinancialReason.order_payment, FinancialReason.order_sponsored]) }
  scope :created_at, ->(begin_datetime, end_datetime) { where(created_at: begin_datetime..end_datetime) }
  scope :withdrawals, -> { where(financial_reason: FinancialReason.withdrawal) }
  scope :by_contract, ->(contract) { where(bonus_contract: contract) }
  scope :created_after, ->(days) { where(created_at: days.days.ago.beginning_of_day..Time.now) }

  validates :cent_amount, presence: true,
                          numericality: { only_integer: true }

  validates :financial_reason, presence: true,
                               unless: :is_note_present?
  validates :note, presence: true, on: :expense
  validates :user, presence: true, on: :expense
  validates :financial_reason, presence: true, on: :expense
  validates :cent_amount, presence: true,
                          numericality: { greater_than: 0 }, on: :expense

  #after_commit :debits_bonus_of_contract, on: :create,
  #                                        if: :payment_bonus?,
  #                                        unless: proc { chargeback? || financial_reason_yield_bonus? }

  after_commit :inactive_free_contract, on: :create, if: :max_contract_gains?

  def chargeback!
    create_chargeback!(user: User.find_morenwm_customer_admin,
                       spreader: user,
                       financial_reason: FinancialReason.chargeback,
                       order: order,
                       cent_amount: cent_amount.to_f,
                       moneyflow: invert_money_flow)
  end

  def chargeback?
    financial_transaction
  end

  def chargeback_binary_score!(financial_reason, amount)
    create_chargeback!(user: User.find_morenwm_customer_admin,
                       spreader: user,
                       financial_reason: financial_reason,
                       cent_amount: amount.to_f,
                       moneyflow: invert_money_flow,
                       order: order,
                       bonus_contract: bonus_contract)
  end

  def chargeback_by_inactivity!(reason = FinancialReason.chargeback_by_inactivity)
    chargeback_binary_score!(reason, cent_amount)
  end

  def chargeback_by_unqualification!
    chargeback_binary_score!(FinancialReason.chargeback_by_unqualification, cent_amount)
  end

  def chargeback_excess_monthly!(amount)
    chargeback_binary_score!(FinancialReason.chargeback_excess_monthly, amount)
  end

  def chargeback_excess_weekly!(amount)
    chargeback_binary_score!(FinancialReason.chargeback_excess_weekly, amount)
  end

  def cent_amount
    self[:cent_amount] / 1e8.to_f if self[:cent_amount]
  end

  def cent_amount=(amount)
    self[:cent_amount] = (amount * 1e8).to_i
  end

  def chargeback_by_career_trail_excess!(amount)
    chargeback_binary_score!(FinancialReason.career_trail_excess_bonus, amount)
    user.inactivate!
  end

  def financial_reason_type_bonus?
    financial_reason.try(:financial_reason_type) == FinancialReasonType.bonus
  end

  def payment_bonus?
    financial_reason_type_bonus? && credit?
  end

  def binary_bonus_chargeback_by_daily_excees(amount)
    reason = FinancialReason.binary_bonus_chargeback_by_daily_excees
    chargeback_binary_score!(reason, amount)
  end

  def direct_or_indirect_bonus?
    direct_and_indirect_bonus = [ FinancialReason.direct_commission_bonus,
                                  FinancialReason.indirect_referral_bonus ]
    financial_reason && financial_reason.in?(direct_and_indirect_bonus)
  end

  def financial_reason_yield_bonus?
    financial_reason == FinancialReason.yield_bonus
  end

  private

  def invert_money_flow
    FinancialTransaction.moneyflows.keys.detect { |e| e != moneyflow }
  end

  def is_note_present?
    note.present?
  end

  def chargeback_to_admin
    create_chargeback!(user: User.find_morenwm_customer_admin,
                       spreader: user,
                       financial_reason: financial_reason,
                       order: order,
                       cent_amount: cent_amount,
                       moneyflow: invert_money_flow)
  end

  def debits_bonus_of_contract
    Financial::BonusContractDistributorService.call(financial_transaction: self)
  end

  def inactive_free_contract
    bonus_contract.update(paid_at: Time.now)
    if bonus_contract.maxed_out_gains?
      admin = User.find_morenwm_customer_admin
      admin.financial_transactions.create!(spreader: user,
                                           financial_reason: FinancialReason.chargeback_by_contract_limit,
                                           cent_amount: bonus_contract.maxed_out_gains,
                                           moneyflow: :debit,
                                           bonus_contract: bonus_contract)
    end
    active_bonus_contracts = user.bonus_contracts.active.yield_contracts.order(:created_at)
    user.inactivate! unless active_bonus_contracts.any?(&:active?)
  end

  def max_contract_gains?
    bonus_contract.max_contract_gains? if bonus_contract.present?
  end
end
