module Backoffice
  class WithdrawalsController < EntrepreneurController
    before_action :ensure_bank_account_valid
    before_action :validate_password, only: :create
    before_action :ensure_withdrawal, only: %i[edit update]
    before_action :ensure_waiting_status, only: %i[edit update]

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
        Financial::CreatorWithdrawalService.call({ form: @form }, params[:locale])
        flash[:success] = t('.success')
        redirect_to backoffice_withdrawals_path
      else
        flash[:error] = @form.errors.full_messages.join(', ')
        render :new
      end
    end

    def edit; end

    def update
      Financial::UpdaterWithdrawalStatusService.call({ updater_user: current_user,
                                                       status: params[:status] ? params[:status].to_i : nil,
                                                       withdrawal: @withdrawal }, params[:locale])
      flash[:success] = t('.success')
      redirect_to backoffice_withdrawals_path
    rescue Exception => error
      flash[:error] = error
      render :edit
    end

    private

    def ensure_withdrawal
      @withdrawal = Withdrawal.find_by_hashid(params[:id])
    end

    def ensure_waiting_status
      if @withdrawal.status.to_sym != :waiting
        flash[:error] = t('request_already_processed')
        redirect_to backoffice_withdrawals_path
      end
    end

    def valid_params
      params.require(:withdrawal_form)
            .permit(:amount, :fiscal_document_link, :fiscal_document_photo)
            .merge(user: current_user)
    end

    def validate_password
      return if current_user.valid_password?(params[:withdrawal_form][:password])
      flash[:error] = t('invalid_password')
      redirect_to [:new, :backoffice, :withdrawal]
    end
  end
end
