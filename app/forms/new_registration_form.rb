class NewRegistrationForm < Form

  attribute :sponsor_username
  attribute :username
  attribute :name
  attribute :birthdate
  attribute :marital_status
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
  attribute :registration_type, String, default: 'pf'
  attribute :gender
  attribute :phone
  attribute :email
  attribute :password
  attribute :password_confirmation
  attribute :accept_terms, Boolean

  validates :sponsor_username, :username, :name, :phone, :email, :password,
            :password_confirmation, :zipcode, :district, :city, :state,
            :gender, :marital_status, :document_cpf, presence: true
  validates :email, email: true

  validates :document_rg, :document_rg_expeditor, :document_pis, presence: true, if: -> { registration_type == 'pf' }
  validates :document_cnpj, :document_ie, :document_company_name, :document_fantasy_name, presence: true, if: -> { registration_type == 'pj' }

  validates :username, format: { with: /\A[a-z0-9\_]+\z/ }

  validate :terms_accepted
  validate :sponsor_exists
  validate :username_is_unique
  validate :email_is_unique
  validate :document_cpf_is_unique

  before_validation :normalize_username

  def sponsor
    @sponsor ||= User.where(
      'LOWER(username) = ? AND role = ?',
      sponsor_username.downcase, :empreendedor
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

end
