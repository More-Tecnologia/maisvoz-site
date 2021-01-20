module Orders
  class PaymentWithBalanceService < ApplicationService
    def call
      ActiveRecord::Base.transaction do
        validate_user_balance
        debit_user_balance

        { former_balance: @former_balance,
          balance: @user.available_balance }
      end
    end

    private

    def initialize(args)
      @user = args[:user]
      @order = args[:order]
      @former_balance = @user.available_balance_cents
    end

    def validate_user_balance
      return if @user.available_balance >= @order.total_value

      raise I18n.t('errors.messages.not_enough_balance')
    end

    def debit_user_balance
      @user.financial_transactions
           .create!(financial_reason: FinancialReason.order_payment_with_balance,
                    moneyflow: :debit,
                    cent_amount: @order.total_value,
                    order: @order)
    end
  end
end
