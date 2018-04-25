class EditRegistrationForm < Form

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

  validates :name, :phone, :skype, :email, presence: true
  validates :email, email: true

  validate :valid_password

  def sponsor
    User.find_by(username: sponsor_username)
  end

  private

  def valid_password
    return if password.blank? && current_password.blank?
    if password.size < 6
      errors.add(:password, 'too short')
    elsif password != password_confirmation
      errors.add(:password, 'passwords dont match')
    end
  end

end
