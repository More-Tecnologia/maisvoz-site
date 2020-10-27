module CreditDebitWizard
  class FindUserForm < Form

    attribute :username, String
    attribute :email, String

    validates :username, :email, presence: true

    validate :user_exists

    def user
      @user ||= User.find_by(username: username, email: email)
    end

    private

    def user_exists
      return if user.present?
      errors.add(:username, I18n.t('errors.messages.required'))
    end

  end

  class CreateForm < FindUserForm

    attribute :amount, String
    attribute :financial_reason_id, String
    attribute :credit, Boolean, default: true
    attribute :master_password, String
    attribute :note, String

    validates :amount, :master_password,
               presence: true
    validates :note, presence: true,
                     length: { maximum: 100 }

    validates :amount, numericality: { greater_than: 0 }

    validate :master_password_digest

    before_validation :cleasing_amount

    private

    def master_password_digest
      return if authenticate_master_password?
      errors.add(:master_password, :not_authenticate)
    end

    def authenticate_master_password?
      digest = Digest::SHA256.hexdigest(master_password)
      digest == ENV['MASTER_PASSWORD_DIGEST']
    end

    def cleasing_amount
      @amount = amount.to_s.gsub('.','').gsub(',','.').to_f / 100.0
    end
  end
end
