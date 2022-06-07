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
  attribute :token

  validates :username, :country, :email, :sponsor_username, presence: true
  validates :sponsor, presence: { message: :invalid }
  validates :email, email: true
  validates :password,  presence: true,
                        length: { minimum: 6 },
                        confirmation: true

  validates :username, format: { with: /\A[a-z0-9\_]+\z/,
                                 message: I18n.t('activemodel.errors.models.new_registration_form.attributes.username.format') },
                      length: { minimum: 9, message: I18n.t('activerecord.errors.messages.too_short', count: 9) }

  validate :username_is_unique
  validate :email_is_unique
  validate :recaptcha

  before_validation :normalize_usernames

  def sponsor
    return if token.blank? && sponsor_username.blank?

    query = { role: [:empreendedor, :consumidor] }
    query.merge!(token.present? ? { token: token } : { username: sponsor_username })

    @sponsor ||= User.find_by(query)
  end

  private

  def normalize_usernames
    if token.present?
     @sponsor_username = I18n.transliterate(sponsor_username.to_s.gsub(/\D+/, '').downcase)
    end
    @username = I18n.transliterate(username.to_s.gsub(/\D+/, '').downcase)
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

  def recaptcha
    validate_recaptcha = RecaptchaValidatorService.call(token: g_recaptcha_response)
    errors.add(:g_recaptcha_response, :invalid) unless validate_recaptcha
  end
end
