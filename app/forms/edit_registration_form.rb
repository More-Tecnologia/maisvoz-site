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

  validates :name, :document_cpf, :country, presence: true

  validate :valid_password

  def sponsor
    User.find_by(username: sponsor_username)
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

end
