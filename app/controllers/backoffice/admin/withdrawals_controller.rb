module Backoffice
  module Admin
    class WithdrawalsController < FinancialController

      def index
        render(:index, locals: { withdrawals: withdrawals, q: q })
      end

      def update
        command = Financial::UpdateWithdrawalStatus.call(current_user, params)

        if command.success?
          flash[:success] = I18n.t('.success')
        else
          flash[:error] = command.errors
        end

        redirect_to backoffice_admin_withdrawals_path
      end

      private

      def withdrawals
        @withdrawals ||= q.result.page(params[:page]).decorate
      end

      def q
        @q ||= Withdrawal.ransack(params[:q])
        @q.sorts = 'created_at desc' if @q.sorts.empty?
        @q
      end

    end
  end
end
