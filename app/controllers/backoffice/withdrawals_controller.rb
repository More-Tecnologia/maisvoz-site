module Backoffice
  class WithdrawalsController < EntrepreneurController
    before_action :ensure_instance_withdrawal, only: :create
    before_action :validate_password, only: :create
    before_action :ensure_withdrawal, only: %i[edit update]
    before_action :ensure_waiting_status, only: %i[edit update]
    before_action :validate_current_time, only: %i[new create]
    before_action :validate_none_withdrawal_pending_or_waiting, only: %i[new create]
    before_action :ensure_status, only: :index

    def index
      @withdrawals = current_user.withdrawals
                                 .__send__(params[:status].to_sym)
                                 .order(created_at: :desc)
                                 .page(params[:page])
                                 .per(10)
                                 .decorate
    end

    def new
      @form = WithdrawalForm.new(user: current_user)
    end

    def create
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
    rescue StandardError => error
      flash[:error] = error
      render :edit
    end

    private

    def ensure_status
      if params[:status].nil?
        params[:status] = 'all'
      end
    end

    def ensure_instance_withdrawal
      @form = WithdrawalForm.new(valid_params)
    end

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
            .permit(:amount, :fiscal_document_link, :fiscal_document_photo,
                    :wallet_address, :pix_wallet, :payment_method)
            .merge(user: current_user)
    end

    def validate_password
      return if current_user.valid_password?(params[:withdrawal_form][:password])
      flash[:error] = t('invalid_password')
      redirect_to [:new, :backoffice, :withdrawal]
    end

    def validate_current_time
      current_time = DateTime.current.in_time_zone('GMT')
      friday_after_20_hours = current_time.friday? && current_time.hour >= 20
      saturday = current_time.saturday?
      sunday_before_20_hours = current_time.sunday? && current_time.hour <= 20

      if friday_after_20_hours || saturday || sunday_before_20_hours
        flash[:alert] = t('defaults.errors.withdrawal_invalid_time')
        redirect_back(fallback_location: root_path)
      end
    end

    def validate_none_withdrawal_pending_or_waiting
      return if current_user.withdrawals.where(status: [:pending , :waiting]).none?

      flash[:alert] = t('defaults.errors.withdrawal_pending')
      redirect_to backoffice_withdrawals_path
    end
  end
end
