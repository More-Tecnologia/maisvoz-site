class WithdrawalForm < Form

  attribute :amount
  attribute :user, User

  validates :amount, presence: true
  validates :amount_cents, numericality: { greater_than: 0 }

  validate :user_has_balance

  def amount_cents
    Integer(amount.to_d * 100)
  end

  def net_amount_cents
    amount_cents * fee
  end

  private

  def user_has_balance
    return if amount_cents <= user.available_balance_cents
    errors.add(:amount, I18n.t('defaults.errors.no_funds'))
  end

  def fee
    1 - ENV['WITHDRAWAL_FEE'].to_d
  end

end
