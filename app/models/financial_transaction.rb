class FinancialTransaction < ApplicationRecord

  include Hashid::Rails

  belongs_to :user
  belongs_to :spreader, class_name: 'User', optional: true
  belongs_to :financial_reason, optional: true
  belongs_to :order, optional: true
  belongs_to :financial_transaction, optional: true
  belongs_to :withdrawal, optional: true

  has_one :chargeback, class_name: 'FinancialTransaction',
                       foreign_key: 'financial_transaction_id'

  enum moneyflow: [:credit, :debit]

  monetize :cent_amount, as: :amount_cents

  scope :chargeback, -> { where.not(financial_transaction: nil) }
  scope :not_chargeback, -> { where(financial_transaction: nil) }
  scope :includes_associations, -> { includes(:user, :spreader, :financial_reason,
                                             :order, :financial_transaction, :chargeback) }
  scope :by_user, ->(user) { includes_associations.where(user: user) }
  scope :financial_reason_bonus,
    -> { includes_associations.where(financial_reason: FinancialReason.bonus) }

  validates :cent_amount, presence: true,
                          numericality: { only_integer: true }

  validates :financial_reason, presence: true,
                               unless: :is_note_present?

  after_create :create_financial_log, if: :is_bonus_and_spreader_not_admin?
  after_create :update_balance_user
  after_create :inactivate_user!, if: :financial_reason_type_bonus?

  def chargeback!
    create_chargeback!(user: user,
                       spreader: User.find_morenwm_customer_admin,
                       financial_reason: FinancialReason.chargeback,
                       order: order,
                       cent_amount: cent_amount,
                       moneyflow: invert_money_flow)
  end

  def chargeback?
    financial_transaction
  end

  def chargeback_binary_score!(financial_reason, amount)
    create_chargeback!(user: user,
                       financial_reason: financial_reason,
                       cent_amount: amount.to_i,
                       moneyflow: invert_money_flow)
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

  private

  def invert_money_flow
    FinancialTransaction.moneyflows.keys.detect { |e| e != moneyflow }
  end

  def is_note_present?
    note.present?
  end

  def update_balance_user
    amount = debit? ? -self[:cent_amount] : self[:cent_amount]
    return user.update_available_balance!(amount) if user.admin?
    return user.update_blocked_balance!(amount) if financial_reason_type_bonus?
    user.update_available_balance!(amount)
  end

  def inactivate_user!
    user.inactivate! if !chargeback? && user.empreendedor? && user.reached_career_trail_maximum_bonus?
  end

  def is_bonus_and_spreader_not_admin?
    financial_reason.is_bonus? && user != User.find_morenwm_customer_admin
  end

  def chargeback_to_admin
    create_chargeback!(user: User.find_morenwm_customer_admin,
                       spreader: user,
                       financial_reason: financial_reason,
                       order: order,
                       cent_amount: cent_amount,
                       moneyflow: invert_money_flow)
  end

  def create_financial_log
    chargeback_to_admin
  end

end
