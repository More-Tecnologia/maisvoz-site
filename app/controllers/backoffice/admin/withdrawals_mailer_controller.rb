module Backoffice
  module Admin
    class WithdrawalsMailerController < FinancialController
      def send_email_confirmation
        withdrawal = Withdrawal.find_by_hashid(params[:withdrawals_mailer_id])
        WithdrawalsMailer.with(withdrawal: withdrawal, locale: params[:locale])
                         .waiting
                         .deliver_later
        flash[:success] = t('.success')
        redirect_to backoffice_admin_withdrawals_path
      end
    end
  end
end
