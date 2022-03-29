module Payment
  class BalanceService < ApplicationService
    def initialize(params)
      @order = params[:order]
      @user = @order.user
    end

    private

    def call
      raise StandardError.new(I18n.t(:doesnt_have_enough_balance)) if @user.available_balance_cents < (@order.total_cents / 100)
      ActiveRecord::Base.transaction do
        create_order_payment
        @order.payment_type = :balance
        @order.status = :pending_payment
        @order.save

        Financial::PaymentCompensation.new(@order).call
      end
    end

    def create_order_payment
      User.find_morenwm_customer_admin
          .financial_transactions
          .create!(spreader: @user,
                   financial_reason: FinancialReason.order_payment_with_balance,
                   cent_amount: (@order.total_cents / 100),
                   moneyflow: :debit)
    end
  end
end
