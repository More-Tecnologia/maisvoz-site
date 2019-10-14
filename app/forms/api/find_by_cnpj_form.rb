module Api
  class FindByCnpjForm < Form

    attribute :cnpj
    attribute :user

    validates :cnpj, presence: true
    validate :user_exists

    def cnpj=(value)
      super CNPJ.new(value).formatted
    end

    def user_serialized
      UserSerializer.new(user).serialize
    end

    private

    def user_exists
      self.user = User.find_by(document_cnpj: cnpj, registration_type: 'pj')
      return if user.present?

      errors.add(:user, 'Inexistente')
    end

  end
end
