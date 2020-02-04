module Backoffice
  class WithdrawalsController < EntrepreneurController

    before_action :ensure_bank_account_valid
    before_action :unavailable_withdrawal

    def index
      @withdrawals = current_user.withdrawals
                                 .order(created_at: :desc)
                                 .page(params[:page]).decorate
    end

    def new
      @form = WithdrawalForm.new(user: current_user)
    end

    def create
      @form = WithdrawalForm.new(valid_params)
      if @form.valid?
        Financial::CreatorWithdrawalService.call(form: @form)
        flash[:success] = t('.success')
        redirect_to backoffice_withdrawals_path
      else
        flash[:error] = @form.errors.full_messages.join(', ')
        render :new
      end
    end

    private

    def valid_params
      params.require(:withdrawal_form)
            .permit(:amount, :fiscal_document_link, :fiscal_document_photo)
            .merge(user: current_user)
    end

    def unavailable_withdrawal
      redirect_to backoffice_dashboard_index_path, alert: 'Withdrawal unavailable yet'
    end

  end
end
