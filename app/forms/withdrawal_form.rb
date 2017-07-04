class WithdrawalForm < Form

  attribute :amount, BigDecimal
  attribute :user, User

  validates :amount, presence: true
  validates :amount, numericality: { greater_than: 0 }

  validate :user_has_balance

  def amount_cents
    Integer(amount * 100)
  end

  private

  def user_has_balance
    return if amount <= user.balance.to_f
    errors.add(:amount, I18n.t('defaults.error.no_funds'))
  end

end
