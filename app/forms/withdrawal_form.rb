class WithdrawalForm < Form

  attribute :amount
  attribute :user, User
  attribute :fiscal_document_link
  attribute :fiscal_document_photo

  validates :amount, presence: true
  validates :amount, numericality: { greater_than_or_equal_to: ENV['WITHDRAWAL_MINIMUM_VALUE'].to_f }

  validate :user_has_balance
  validate :fiscal_document_presence, if: -> { user.pj? }

  def amount_cents
    Integer(amount.to_d * 1e2)
  end

  def net_amount_cents
    amount_cents - fee_cents
  end

  private

  def user_has_balance
    return if amount_cents <= user_balance
    errors.add(:amount, I18n.t('defaults.errors.no_funds'))
  end

  def user_balance
    return user.balance * 1e2 if user.pj?
    user.available_balance_cents * 1e2
  end

  def fiscal_document_presence
    return if fiscal_document_link.present? || fiscal_document_photo.present?
    errors.add(:fiscal_document_link, 'precisamos da nota')
  end

  def fee_cents
    ENV['WITHDRAWAL_FEE'].to_d * 1e2
  end

end
