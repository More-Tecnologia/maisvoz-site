module Backoffice
  class WithdrawalsController < BackofficeController

    def index
      render(:index, locals: { withdrawals: withdrawals })
    end

    def new
      render(:new, locals: { form: WithdrawalForm.new })
    end

    def create
      command = Financial::CreateWithdrawal.call(current_user, params)

      if command.success?
        flash[:success] = I18n.t('defaults.success')
        redirect_to backoffice_withdrawals_path
      else
        render(:new, locals: { form: command.result })
      end
    end

    private

    def withdrawals
      current_user.withdrawals.order(created_at: :desc).page(params[:page])
    end

  end
end
