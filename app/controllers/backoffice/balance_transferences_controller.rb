module Backoffice
  class BalanceTransferencesController < BackofficeController
    before_action :disable_balance_transference, only: %i[create]
    before_action :validate_destination_user, only: %i[new create]
    before_action :validate_current_user_password, only: :create

    def index
      @q = FinancialTransaction.ransack(params[:q])
      @financial_transactions = @q.result
                                  .includes(:user)
                                  .where(spreader: current_user)
                                  .where(financial_reason: FinancialReason.balance_transference)
                                  .order(created_at: :desc)
                                  .page(params[:page])
    end

    def new; end

    def create
      Financial::BalanceTransferenceService.call(source_user: current_user,
                                                 transfer_value: params[:cent_amount],
                                                 destination_user: @destination_user)
      flash[:notice] = t('.success')
      redirect_to backoffice_balance_transferences_path
    rescue StandardError => error
      flash[:error] = errors.message
      redirect_back(fallback_location: root_path)
    end

    private

    def validate_destination_user
      @destination_user ||= User.find_by(params.slice(:username, :email))

      if @destination_user.blank? || @destination_user.inactive?
        flash[:alert] = I18n.t('defaults.errors.user_not_found_or_inactive')
        redirect_back(fallback_location: root_path)
      end
    end

    def validate_current_user_password
      return if current_user.valid_password?(params[:password])

      flash[:alert] = I18n.t('errors.messages.invalid_password')
      redirect_back(fallback_location: root_path)
    end

    def disable_balance_transference
      flash[:error] = 'Transaction unauthorized'
      redirect_back(fallback_location: root_path)
    end
  end
end
