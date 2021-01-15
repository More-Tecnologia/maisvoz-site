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
      @order = current_user.orders.find_by_hashid(params[:order_id])
      return if @order && @order.pending_payment?

      flash[:alert] = t('errors.messages.order_not_found')
      redirect_back(fallback_location: root_path)
    end

    def validate_order_amount_greater_than_current_order_amount
      current_contract = current_user.bonus_contracts.active.yield_contracts.first
      return if @order.total_cents > current_contract.try(:order).try(:total_cents).to_f

      flash[:alert] = t('errors.messages.order_amount_invalid')
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
