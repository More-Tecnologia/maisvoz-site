class ShortNewRegistrationForm < Form

  attribute :role
  attribute :sponsor_username
  attribute :sponsor
  attribute :username
  attribute :name
  attribute :document_cpf
  attribute :country
  attribute :email
  attribute :password
  attribute :password_confirmation
  attribute :g_recaptcha_response
  attribute :registration_type

  validates :username, :name, :email, :sponsor, presence: true
  validates :email, email: true
  validates :sponsor_username, presence: true
  validates :username, format: {
    with: /\A[a-z0-9\_]+\z/,
    message: I18n.t('activemodel.errors.models.new_registration_form.attributes.username.format')
  }
  validate :sponsor_exists
  validate :username_is_unique
  validate :email_is_unique
  validates :password,  presence: true,
                        length: { minimum: 6 },
                        confirmation: true
  validate :recaptcha

  before_validation :normalize_username

  def sponsor
    @sponsor ||= User.where(
      'LOWER(username) = ? AND role = ?',
      sponsor_username.try(:downcase), :empreendedor
    ).first
  end

  private

  def normalize_username
    if username.present?
      self.username = username.gsub(/\s+/, '').downcase
    end
  end

  def sponsor_exists
    return if sponsor.present?
    errors.add(:sponsor_username, :invalid)
  end

  def username_is_unique
    return unless User.where('LOWER(username) = ?', username).any?
    errors.add(:username, :taken)
  end

  def email_is_unique
    return unless User.where(email: email).any?
    errors.add(:email, I18n.t('activemodel.errors.messages.taken'))
  end

  def role
    @role ||= :empreendedor
  end

  def registration_type
    @registration_type ||= :pf
  end

  def valid_password
    return if password.blank? && password_confirmation.blank?
    if password.size < 6
      errors.add(:password, 'muito pequeno')
    elsif password != password_confirmation
      errors.add(:password, 'as senhas não são as mesmas')
    end
  end

  def recaptcha
    validate_recaptcha = RecaptchaValidatorService.call(token: g_recaptcha_response)
    errors.add(:g_recaptcha_response, :invalid) unless validate_recaptcha
  end

end
