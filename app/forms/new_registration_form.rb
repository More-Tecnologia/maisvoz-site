class NewRegistrationForm < Form

  attribute :role
  attribute :sponsor_username
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
  attribute :accept_terms, Boolean

  validates :role, :username, :name, :phone, :email, :password,
            :password_confirmation, :gender, :document_cpf, presence: true
  validates :email, email: true
  validates :sponsor_username, presence: true, unless: -> { installer? }

  validates :document_rg, :document_rg_expeditor, presence: true, if: -> { pf? }
  validates :document_cnpj, :document_ie, :document_company_name, :document_fantasy_name, presence: true, if: -> { pj? }

  validates :username, format: { with: /\A[a-z0-9\_]+\z/ }

  validate :terms_accepted
  validate :sponsor_exists, unless: -> { installer? }
  validate :username_is_unique
  validate :email_is_unique
  validate :document_cpf_is_unique
  # validate :city_exists

  before_validation :normalize_username

  def sponsor
    @sponsor ||= User.where(
      'LOWER(username) = ? AND role = ?',
      sponsor_username.downcase, :empreendedor
    ).first
  end

  def pf?
    role == 'pf'
  end

  def pj?
    role == 'pj'
  end

  def installer?
    role == 'installer'
  end

  private

  def normalize_username
    if username.present?
      self.username = username.gsub(/\s+/, '').downcase
    end
  end

  def sponsor_exists
    return if sponsor.present?
    errors.add(:sponsor_username, 'patrocinador não encontrado, ou não está ativo')
  end

  def username_is_unique
    return unless User.where('LOWER(username) = ?', username).any?
    errors.add(:username, 'já existe')
  end

  def email_is_unique
    return unless User.where(email: email).any?
    errors.add(:email, 'já existe')
  end

  def document_cpf_is_unique
    return unless User.where(document_cpf: document_cpf).any?
    errors.add(:document_cpf, 'já existe')
  end

  def terms_accepted
    return if accept_terms
    errors.add(:accept_terms, 'deve aceitar os termos')
  end

  def city_exists
    return if City.exists?(name: city)
    errors.add(:city, 'não existe')
  end

end
