module CreditDebitWizard
  class FindUserForm < Form

    attribute :username, String

    validate :user_exists

    def user
      @user ||= User.find_by(username: username)
    end

    private

    def user_exists
      return if user.present?
      errors.add(:username, I18n.t('errors.messages.required'))
    end

  end

  class CreateForm < FindUserForm

    attribute :amount, String
    attribute :credit, Boolean, default: true
    attribute :master_password, String

    validates :username, :amount, :master_password, presence: true
    validates :amount, numericality: { greater_than: 0 }

    validate :correct_master_password

    private

    def correct_master_password
      command = AuthenticateMaster.call(master_password)
      return if command.success?
      errors.add(:master_password, I18n.t('errors.messages.wrong_master_pw'))
    end

  end
end