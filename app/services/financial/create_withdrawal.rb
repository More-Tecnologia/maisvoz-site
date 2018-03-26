module Financial
  class CreateWithdrawal

    prepend SimpleCommand

    def initialize(user, params)
      @user = user
      @params = params
    end

    def call
      if form.valid?
        ActiveRecord::Base.transaction do
          withdrawal = create_withdrawal
          withdrawal.update!(fiscal_document_photo: form.fiscal_document_photo)
          debit_balance
        end
      else
        errors.add(:form, 'invalid')
      end
      form
    end

    private

    attr_reader :user, :params

    def create_withdrawal
      Withdrawal.new.tap do |withdrawal|
        withdrawal.user                  = user
        withdrawal.status                = Withdrawal.statuses[:pending]
        withdrawal.gross_amount_cents    = form.amount_cents
        withdrawal.net_amount_cents      = form.net_amount_cents
        withdrawal.fiscal_document_link  = form.fiscal_document_link
        withdrawal.save!
      end
    end

    def debit_balance
      if user.pf?
        user.decrement!(:available_balance_cents, form.amount_cents)
      elsif user.pj?
        if form.amount_cents > user.available_balance_cents
          diff = form.amount_cents - user.available_balance_cents
          user.decrement!(:available_balance_cents, user.available_balance_cents)
          user.decrement!(:blocked_balance_cents, diff)
        else
          user.decrement!(:available_balance_cents, form.amount_cents)
        end
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
