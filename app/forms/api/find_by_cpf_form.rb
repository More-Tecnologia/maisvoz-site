module Api
  class FindByCpfForm < Form

    attribute :cpf
    attribute :user

    validates :cpf, presence: true

    validate :user_exists

    def cpf=(value)
      super CPF.new(value).formatted
    end

    def user_serialized
      UserSerializer.new(user).serialize
    end

    private

    def user_exists
      self.user = User.find_by(document_cpf: cpf)
      return if user.present?

      errors.add(:user, 'Inexistente')
    end

  end
end