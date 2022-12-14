module Api
  class SignupForm < Form

    attribute :sponsor_username
    attribute :username
    attribute :name
    attribute :email
    attribute :cpf_cnpj
    attribute :password

    validates :sponsor_username, :username, :name, :email, :cpf_cnpj, :password, presence: true
    validates :username, format: { with: /\A[a-z0-9\_]+\z/ }
    validates :email, email: true

    validate :valid_sponsor
    validate :username_available
    validate :email_unique
    validate :document_is_unique
    validate :document_is_valid
    validate :strong_password

    def sponsor
      @sponsor ||= User.find_by(username: sponsor_username)
    end

    def cpf
      return unless CPF.valid?(cpf_cnpj)
      @cpf ||= cpf_cnpj
    end

    def cnpj
      return unless CNPJ.valid?(cpf_cnpj)
      @cnpj ||= cpf_cnpj
    end

    def registration_type
      if cnpj.present?
        'pj'
      else
        'pf'
      end
    end

    private

    def valid_sponsor
      if sponsor.blank?
        errors.add(:sponsor_username, 'Não existe')
      elsif !sponsor.active?
        errors.add(:sponsor_username, 'Inativo')
      end
    end

    def username_available
      return unless User.exists?(username: username)

      errors.add(:username, 'Indisponível')
    end

    def email_unique
      return unless User.exists?(email: email)

      errors.add(:email, 'Já cadastrado')
    end

    def document_is_unique
      if registration_type == 'pf'
        return unless User.exists?(document_cpf: cpf_cnpj)
      else
        return unless User.exists?(document_cnpj: cpf_cnpj)
      end

      errors.add(:cpf_cnpj, 'Já cadastrado')
    end

    def document_is_valid
      return if CPF.valid?(cpf_cnpj)
      return if CNPJ.valid?(cpf_cnpj)

      errors.add(:cpf_cnpj, 'Inválido')
    end

    def strong_password
      return if password.blank?

      checker = StrongPassword::StrengthChecker.new(min_entropy: 4)
      return if checker.is_strong?(password)

      errors.add(:password, 'Senha fraca')
    end

  end
end
