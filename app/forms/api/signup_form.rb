module Api
  class SignupForm < Form

    attribute :sponsor_username
    attribute :username
    attribute :name
    attribute :email
    attribute :cpf
    attribute :password

    validates :sponsor_username, :username, :name, :email, :cpf, :password, presence: true
    validates :username, format: { with: /\A[a-z0-9\_]+\z/ }
    validates :email, email: true

    validate :valid_sponsor
    validate :username_available
    validate :email_unique
    validate :document_cpf_is_unique
    validate :cpf_is_valid
    validate :strong_password

    def sponsor
      @sponsor ||= User.find_by(username: sponsor_username)
    end

    private

    def valid_sponsor
      if sponsor.blank?
        errors.add(:sponsor_username, 'patrocinador não existe')
      elsif !sponsor.active?
        errors.add(:sponsor_username, 'patrocinador inativo')
      end
    end

    def username_available
      return unless User.exists?(username: username)

      errors.add(:username, 'nome de usuário indisponível')
    end

    def email_unique
      return unless User.exists?(email: email)

      errors.add(:email, 'email já cadastrado')
    end

    def document_cpf_is_unique
      return unless User.exists?(document_cpf: cpf)

      errors.add(:cpf, 'CPF já cadastrado')
    end

    def cpf_is_valid
      return if CPF.valid?(cpf)

      errors.add(:cpf, 'CPF inválido')
    end

    def strong_password
      checker = StrongPassword::StrengthChecker.new(password)
      return if checker.is_strong?(min_entropy: 4)

      errors.add(:password, 'senha fraca')
    end

  end
end
