class EditRegistrationForm < Form

  attribute :id
  attribute :avatar
  attribute :name
  attribute :birthdate
  attribute :marital_status
  attribute :phone
  attribute :skype
  attribute :email
  attribute :document_cpf
  attribute :document_rg
  attribute :document_rg_expeditor
  attribute :document_pis
  attribute :document_cnpj
  attribute :document_ie
  attribute :document_fantasy_name
  attribute :document_company_name
  attribute :zipcode
  attribute :address_ibge
  attribute :address
  attribute :address_2
  attribute :district
  attribute :country
  attribute :state
  attribute :city
  attribute :password
  attribute :password_confirmation
  attribute :current_password
  attribute :registration_type

  validates :name, :phone, :document_cpf, :address, :zipcode, :district, :city, :country, :state, :email, presence: true
  validates :email, email: true

  validate :document_cpf_is_unique
  validate :valid_password
  validate :valid_cpf
  validate :valid_cnpj, if: :pj?

  def sponsor
    User.find_by(username: sponsor_username)
  end

  def pf?
    registration_type == 'pf'
  end

  def pj?
    registration_type == 'pj'
  end

  private

  def valid_password
    return if password.blank? && current_password.blank?

    if password.size < 6
      errors.add(:password, 'muito pequeno')
    elsif password != password_confirmation
      errors.add(:password, 'as senhas não são as mesmas')
    end
  end

  def valid_cpf
    return if CPF.valid? document_cpf

    errors.add(:document_cpf, :invalid)
  end

  def valid_cnpj
    return if document_cnpj.blank?
    return if CNPJ.valid? document_cnpj

    errors.add(:document_cnpj, :invalid)
  end

  def document_cpf_is_unique
    return unless User.where(document_cpf: document_cpf).where('id != ?', id).exists?

    errors.add(:document_cpf, :taken)
  end

end
