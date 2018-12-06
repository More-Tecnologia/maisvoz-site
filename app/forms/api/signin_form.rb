module Api
  class SigninForm < Form

    attribute :login
    attribute :password
    attribute :user

    validates :login, :password, presence: true

    def verified?
      user = User.find_for_database_authentication(login: login)
      self.user = user&.valid_password?(password) ? user : false
    end

    def user_serialized
      UserSerializer.new(user).serialize
    end

  end
end