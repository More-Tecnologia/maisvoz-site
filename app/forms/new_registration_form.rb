class NewRegistrationForm < Form

  attribute :sponsor_username
  attribute :sponsor
  attribute :username
  attribute :name
  attribute :birthdate
  attribute :document_rg
  attribute :document_rg_expeditor
  attribute :document_cpf
  attribute :document_pis
  attribute :document_cnpj
  attribute :document_ie
  attribute :document_company_name
  attribute :document_fantasy_name
  attribute :address_ibge
  attribute :address
  attribute :address_2
  attribute :address_number
  attribute :district
  attribute :city
  attribute :state
  attribute :country
  attribute :zipcode
  attribute :gender
  attribute :phone
  attribute :email
  attribute :password
  attribute :password_confirmation
  attribute :registration_type
  attribute :contract

  validates :username, :name, :phone, :email, :password,
            :password_confirmation, :gender, :zipcode, :address,
            :district, :city, :state, :sponsor, :birthdate, :registration_type,
            presence: true
  validates :email, email: true
  validates :sponsor_username, presence: true

  validates :document_cpf, presence: true
  validates :document_cnpj, :document_ie, :document_company_name, :document_fantasy_name, presence: true, if: -> { pj? }

  validates :username, format: { with: /\A[a-z0-9\_]+\z/,
                                 message: I18n.t('activemodel.errors.models.new_registration_form.attributes.username.format') }

  validate :sponsor_exists
  validate :username_is_unique
  validate :email_is_unique
  validate :document_cpf_is_unique
  validate :document_cnpj_is_unique, if: :pj?
  validate :cpf_and_cnpj_format
  validates :contract, presence: true, acceptance: true

  before_validation :normalize_username

  def sponsor
    @sponsor ||= User.where(
      'LOWER(username) = ? AND role = ?',
      sponsor_username.try(:downcase), :empreendedor
    ).first
  end

  def pf?
    registration_type == 'pf'
  end

  def pj?
    registration_type == 'pj'
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

  def document_cpf_is_unique
    user_exists = User.exists?(document_cpf: document_cpf)
    errors.add(:document_cpf,
               I18n.t('activemodel.errors.messages.taken')) if user_exists
  end

  def city_exists
    return if City.exists?(name: city)
    errors.add(:city, :invalid)
  end

  def cpf_and_cnpj_format
    errors.add(:document_cpf) if !CPF.valid?(document_cpf)
    errors.add(:document_cnpj) if !CNPJ.valid?(document_cnpj) && pj?
  end

  def document_cnpj_is_unique
    user_exists = User.exists?(document_cnpj: document_cnpj)
    errors.add(:document_cnpj,
               I18n.t('activemodel.errors.messages.taken')) if user_exists
  end

end
