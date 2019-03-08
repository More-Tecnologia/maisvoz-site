class UpdateBankAccount

  def initialize(form)
    @form = form
    @user = form.user
  end

  def call
    user.bank_account_type = form.bank_account_type
    user.bank_account      = form.bank_account
    user.bank_agency       = form.bank_agency
    user.bank_code         = form.bank_code
    user.save!
  end

  private

  attr_reader :form, :user

end
