module Backoffice
  module Admin
    class WithdrawalsController < FinancialController
      include ActionView::Helpers::NumberHelper

      def index
        @q = Withdrawal.ransack(params[:q])
        withdrawals = @q.result
                        .includes(:user)
                        .order(created_at: :desc)

        respond_to do |format|
          format.html { @withdrawals = withdrawals.page(params[:page]).decorate }
          format.csv { render_as_csv(withdrawals) }
        end
      end

      def update
        withdrawal = Withdrawal.find(params[:id])
        Financial::UpdaterWithdrawalStatusService.call({ updater_user: current_user,
                                                         status: params[:status] ? params[:status].to_i : nil,
                                                         withdrawal: withdrawal }, params[:locale])
        if params[:status].to_i == Withdrawal.statuses[:approved]
          flash[:success] = t('.success')
        else
          flash[:error] = t('.rejected')
        end
        redirect_to backoffice_admin_withdrawals_path
      rescue StandardError => error
        flash[:error] = error
        redirect_to backoffice_admin_withdrawals_path
      end

      def render_as_csv(withdrawals)
        send_data(as_csv(withdrawals),
                  type: 'text/csv',
                  disposition: 'inline',
                  filename: t('defaults.withdrawals') + "-#{Time.now.to_s}.csv")
      end

      def as_csv(withdrawals)
        attributes = %i[hashid username id digital_wallet currency gross_amount
                        net_amount status created_at]
        header = attributes.map { |attr| Withdrawal.human_attribute_name(attr) }

        body = withdrawals.map do |w|
          [
           w.hashid,
           w.user.try(:username),
           w.user.try(:decorate).try(:main_document),
           w.wallet,
           w.user.wallet_currency(w.wallet).to_s.upcase,
           number_to_currency(w.gross_amount_cents, unit: '', precision: 6),
           number_to_currency(w.net_amount_cents, unit: '', precision: 6),
           w.status,
           l(w.created_at, format: :long)
         ]
        end

        CSV.generate do |csv|
          csv << header
          body.each {|b| csv << b }
        end
      end
    end
  end
end
