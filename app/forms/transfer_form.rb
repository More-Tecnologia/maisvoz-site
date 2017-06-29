class TransferForm < Form

  attribute :from_user, User
  attribute :to_username, Account
  attribute :amount, String
  attribute :password, String

  validates :from_user, :to_username, :amount, :password, presence: true
  validates :amount, numericality: { greater_than: 0 }

  validate :to_username_exists
  validate :from_user_has_balance
  validate :valid_password
  validate :valid_destination_account

  def to_user
    @to_user ||= User.find_by(username: to_username)
  end

  private

  def to_username_exists
    return if User.exists?(username: to_username)
    errors.add(:to_username, I18n.t('errors.messages.not_found'))
  end

  def from_user_has_balance
    return if from_user.balance.to_f >= BigDecimal(amount)
    errors.add(:amount, I18n.t('errors.messages.not_enough_balance'))
  end

  def valid_password
    return if from_user.valid_password?(password)
    errors.add(:password, I18n.t('errors.messages.invalid_password'))
  end

  def valid_destination_account
    return if to_user.present? && from_user.account != to_user.account
    errors.add(:to_username, I18n.t('errors.messages.invalid'))
  end

end
