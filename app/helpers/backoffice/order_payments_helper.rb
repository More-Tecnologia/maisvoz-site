module Backoffice
  module OrderPaymentsHelper
    def debit_order_value_from_current_user(user, order)
      ActiveRecord::Base.transaction do
        order.update!(payer: user, payment_type: :balance)

        amount = order.total_cents / 100.0
        user.financial_transactions
            .create!(financial_reason: FinancialReason.thirty_party_order_payment,
                     cent_amount: amount,
                     moneyflow: :debit,
                     order: order)

        order_payment_balance = [0, user.transference_balance - amount].max
        user.update!(transference_balance: order_payment_balance)
      end
    end

    private

    def validate_order_status
      @order = Order.find_by_hashid(params[:order_id])
      return if @order && @order.user.email == params[:email] && @order.pending_payment?

      flash[:alert] = t('errors.messages.order_not_found')
      redirect_back(fallback_location: root_path)
    end

    def validate_order_user_is_direct_referral_from_current_user
      return if @order.user.sponsor == current_user

      flash[:alert] = t('errors.messages.user_not_direct_referral')
      redirect_back(fallback_location: root_path)
    end

    def validates_user_orders_quantity
      return if @order.user.orders.completed.none?

      flash[:alert] = t('errors.messages.invalid_order_quantity')
      redirect_back(fallback_location: root_path)
    end

    def validate_user_password
      return if current_user.valid_password?(params[:password])

      flash[:alert] = I18n.t('activemodel.errors.messages.wrong_password')
      redirect_back(fallback_location: root_path)
    end

    def validate_payer_user_balance
      order_payment_balance =
        current_user.available_balance + current_user.transference_balance
      return if order_payment_balance >= @order.total_cents / 100.0

      flash[:error] = t('errors.messages.not_enough_balance')
      redirect_back(fallback_location: root_path)
    end
  end
end
