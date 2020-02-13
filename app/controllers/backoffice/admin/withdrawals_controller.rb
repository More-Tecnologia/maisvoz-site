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
        if params[:status] == :approved
          flash[:success] = t('.success')
        else
          flash[:error] = t('.rejected')
        end
        redirect_to backoffice_admin_withdrawals_path
      rescue Exception => error
        flash[:error] = error
        redirect_to backoffice_admin_withdrawals_path
      end

      def resend
        withdrawal = Withdrawal.find_by_hashid(params[:withdrawal_id])
        WithdrawalsMailer.with(withdrawal: withdrawal, locale: params[:locale])
                         .waiting
                         .deliver_later
        flash[:success] = t('.success')
        redirect_to backoffice_admin_withdrawals_path
      end
    end
  end
end
