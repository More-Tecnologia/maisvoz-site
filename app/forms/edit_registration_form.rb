class EditRegistrationForm < Form

  attribute :id
  attribute :avatar
  attribute :name
  attribute :birthdate
  attribute :phone
  attribute :skype
  attribute :email
  attribute :document_cpf
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

  validates :name, :phone, :document_cpf, :email, presence: true
  validates :email, email: true

  validate :document_cpf_is_unique
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

  def document_cpf_is_unique
    return unless User.where(document_cpf: document_cpf).where('id != ?', id).exists?
    errors.add(:document_cpf, 'Já está registrado em outra conta')
  end

end
