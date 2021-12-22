module Backoffice::Admin
  class WithdrawalApprovalsController < AdminController
    def new
      @withdrawals ||= Withdrawal.includes(:user)
                                 .processing
                                 .where(id: params[:ids].split(','))
      ActiveRecord::Base.transaction do
        @withdrawals.each do |w|
          Financial::WithdrawalStatusUpdaterService.call({ updater_user: current_user,
                                                           status: :approved,
                                                           withdrawal: w },
                                                           params[:locale])
        end
      end

      flash[:success] = t('.success')
      redirect_to backoffice_admin_withdrawals_path
    end
  end
end
