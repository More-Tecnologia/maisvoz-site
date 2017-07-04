module Financial
  class CreateWithdrawal

    prepend SimpleCommand

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      if form.valid?
        create_withdrawal
      else
        errors.add(:form, 'invalid')
      end
      form
    end

    private

    attr_reader :user, :params

    def create_withdrawal
      ActiveRecord::Base.transaction do
        withdrawal.amount_cents = form.amount_cents
        withdrawal.pending!
        withdrawal.save!
      end
    end

    def withdrawal
      @withdrawal ||= Withdrawal.new(user: user)
    end

    def form_params
      params[:withdrawal_form][:user] = user
      params[:withdrawal_form]
    end

    def form
      @form ||= WithdrawalForm.new(form_params)
    end

  end
end
