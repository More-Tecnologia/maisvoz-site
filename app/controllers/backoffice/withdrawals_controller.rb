module Backoffice
  class WithdrawalsController < EntrepreneurController

    prepend_before_action :ensure_admin_or_entrepreneur, :should_be_verified

    def index
      render(:index, locals: { withdrawals: withdrawals })
    end

    def new
      render(:new, locals: { form: WithdrawalForm.new, withdraw_day: withdraw_day? })
    end

    def create
      return unless withdraw_day?
      command = Financial::CreateWithdrawal.call(current_user, params)

      if command.success?
        flash[:success] = I18n.t('defaults.success')
        redirect_to backoffice_withdrawals_path
      else
        render(:new, locals: { form: command.result, withdraw_day: withdraw_day? })
      end
    end

    private

    def ensure_admin_or_entrepreneur
      return if signed_in? && (current_user.admin? || current_user.empreendedor? || current_user.instalador?)
      flash[:error] = 'Você precisa ser admin ou empreendedor'
      redirect_to root_path
    end

    def withdrawals
      current_user.withdrawals.order(created_at: :desc).page(params[:page]).decorate
    end

    def should_be_verified
      unless current_user.verified?
        flash[:error] = t('.unverified_account')
        redirect_to edit_backoffice_documents_path
      end
    end

    def withdraw_day?
      true
    end

  end
end
