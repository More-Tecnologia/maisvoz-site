class UserForm < Form

  include BankCodes

  attribute :user_id
  attribute :name
  attribute :birthdate
  attribute :phone
  attribute :skype
  attribute :email
  attribute :registration_type
  attribute :document_cpf
  attribute :document_rg
  attribute :document_pis
  attribute :document_rg_expeditor
  attribute :document_cnpj
  attribute :document_ie
  attribute :document_company_name
  attribute :document_fantasy_name
  attribute :zipcode
  attribute :address_ibge
  attribute :address
  attribute :address_2
  attribute :address_number
  attribute :district
  attribute :country
  attribute :state
  attribute :city
  attribute :bank_code
  attribute :bank_agency
  attribute :bank_account
  attribute :password
  attribute :password_confirmation
  attribute :master_leader

  validates :name, :email, presence: true
  validates :email, email: true

  validate :valid_password

  private

  def valid_password
    return if password.blank? && password_confirmation.blank?
    if password.size < 6
      errors.add(:password, 'muito pequeno')
    elsif password != password_confirmation
      errors.add(:password, 'as senhas não são as mesmas')
    end
  end

end
