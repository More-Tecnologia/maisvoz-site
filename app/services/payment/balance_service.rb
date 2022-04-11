# frozen_string_literal: true

module Payment
  class BalanceService < ApplicationService
    def initialize(params)
      @order = params[:order]
      @user = params[:third_party_user].presence || @order.user
    end

    private

    def call
      raise StandardError.new(I18n.t(:doesnt_have_enough_balance)) if @user.available_balance_cents < (@order.total_cents / 100)
      ActiveRecord::Base.transaction do
        create_order_payment
        @order.payment_type = :balance
        @order.status = :pending_payment
        @order.save

        PaymentCompensationWorker.perform_async(@order.id)
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
