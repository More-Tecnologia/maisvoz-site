module Backoffice
  module Admin
    class WithdrawalsController < FinancialController
      def index
        @q = Withdrawal.ransack(params[:q])
        @withdrawals = @q.result
                         .includes(:user)
                         .order(created_at: :desc)
                         .page(params[:page])
                         .decorate
      end

      def update
        withdrawal = Withdrawal.find(params[:id])
        Financial::UpdaterWithdrawalStatusService.call({ updater_user: current_user,
                                                       status: params[:status] ? params[:status].to_i : nil,
                                                       withdrawal: withdrawal }, params[:locale])

        if params[:status].to_s == Withdrawal.statuses[:approved].to_s
          flash[:success] = t('.success')
        else
          flash[:error] = t('.rejected')
        end
        redirect_to backoffice_admin_withdrawals_path
      rescue StandardError => error
        flash[:error] = error
        redirect_to backoffice_admin_withdrawals_path
      end
    end
  end
end
