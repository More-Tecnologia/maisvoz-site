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
  validates :password,  presence: true,
                        length: { minimum: 6 },
                        confirmation: true

  validates :username, format: { with: /\A[a-z0-9\_]+\z/,
                                 message: I18n.t('activemodel.errors.models.new_registration_form.attributes.username.format') },
                      length: { minimum: 5, message: I18n.t('activerecord.errors.messages.too_short', count: 5) }



  validate :sponsor_exists
  validate :username_is_unique
  validate :email_is_unique
  validate :recaptcha

  before_validation :normalize_usernames

  def sponsor
    @sponsor ||= User.where(username: sponsor_username,
                            role: [:empreendedor, :consumidor]).first
  end

  private

  def normalize_usernames
    @sponsor_username = I18n.transliterate(sponsor_username.to_s.gsub(/\s+/, '').downcase)
    @username = I18n.transliterate(username.to_s.gsub(/\s+/, '').downcase)
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
