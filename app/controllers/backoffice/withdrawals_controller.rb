module Backoffice
  class WithdrawalsController < EntrepreneurController

    before_action :should_be_verified

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

    def withdrawals
      current_user.withdrawals.order(created_at: :desc).page(params[:page]).decorate
    end

    def should_be_verified
      unless current_user.verified?
        flash[:error] = 'Sua conta precisa ser verificada antes de poder gerenciar saques'
        redirect_to backoffice_dashboard_index_path
      end
    end

    def withdraw_day?
      return true
      Time.zone.today.day <= 21 && Time.zone.today.monday?
    end

  end
end
