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
      Withdrawal.new.tap do |withdrawal|
        withdrawal.user               = user
        withdrawal.status             = Withdrawal.statuses[:pending]
        withdrawal.gross_amount_cents = form.amount_cents
        withdrawal.net_amount_cents   = form.net_amount_cents
        withdrawal.save!
      end
    end

    def form_params
      params[:withdrawal_form][:user] = user
      params[:withdrawal_form][:amount] = params[:withdrawal_form][:amount].gsub('.', '').gsub(',','.')
      params[:withdrawal_form]
    end

    def form
      @form ||= WithdrawalForm.new(form_params)
    end

  end
end
