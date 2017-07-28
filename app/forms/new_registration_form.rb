class NewRegistrationForm < Form

  attribute :sponsor_username
  attribute :username
  attribute :name
  attribute :phone
  attribute :skype
  attribute :email
  attribute :password
  attribute :password_confirmation
  attribute :accept_terms, Boolean

  validates :sponsor_username, :username, :name, :phone, :skype, :email, :password,
            :password_confirmation, presence: true
  validates :email, email: true

  validate :terms_accepted
  validate :sponsor_exists
  validate :username_is_unique

  def sponsor
    User.find_by(username: sponsor_username, role: :client)
  end

  private

  def sponsor_exists
    return if User.where(username: sponsor_username, role: :client).any?
    errors.add(:sponsor_username, 'sponsor doesnt exist')
  end

  def username_is_unique
    return unless User.where(username: username).any?
    errors.add(:username, 'already exists')
  end

  def terms_accepted
    return if accept_terms
    errors.add(:accept_terms, 'must accept terms')
  end

end
