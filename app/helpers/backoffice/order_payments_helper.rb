module Backoffice
  module OrderPaymentsHelper
    def debit_order_value_from_current_user(user, order)
      ActiveRecord::Base.transaction do
        order.update!(payer: user,  payment_type: :balance)
        user.financial_transactions
            .create!(financial_reason: FinancialReason.thirty_party_order_payment,
                     cent_amount: order.total_cents / 100.0,
                     moneyflow: :debit,
                     order: order)
      end
    end

    private

    def validate_order
      @order = Order.find_by_hashid(params[:order_id])
      return if @order && @order.user.email == params[:email] && @order.pending_payment?

      flash[:alert] = t('errors.messages.order_not_found')
      redirect_back(fallback_location: root_path)
    end

    def validate_user_password
      return if current_user.valid_password?(params[:password])

      flash[:alert] = I18n.t('activemodel.errors.messages.wrong_password')
      redirect_back(fallback_location: root_path)
    end

    def validate_payer_user_balance
      return if current_user.available_balance >= @order.total_cents / 100.0

      flash[:error] = t('errors.messages.not_enough_balance')
      redirect_back(fallback_location: root_path)
    end
  end
end