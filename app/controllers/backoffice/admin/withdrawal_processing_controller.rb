module Backoffice::Admin
  class WithdrawalProcessingController < AdminController
    def new
      withdrawals ||= Withdrawal.includes(:user)
                                .pending
                                .where(id: params[:ids].split(','))
      withdrawals.update_all(status: :processing)

      flash[:success] = t('.success')
      redirect_to backoffice_admin_withdrawals_path
    end
  end
end
