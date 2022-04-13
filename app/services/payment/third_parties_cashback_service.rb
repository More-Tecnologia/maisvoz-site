# frozen_string_literal: true

module Payment
  class ThirdPartiesCashbackService < ApplicationService
    def initialize(params)
      @user = params[:user]
      @order = params[:order]
    end

    private

    def amount_to_cashback
      @order.total_cents.to_f / 1000
    end

    def call
      create_cashback_payment
    end

    def cashback_reason
      FinancialReason.cashback
    end

    def create_cashback_payment
      @user.financial_transactions
           .create!(spreader: User.find_morenwm_customer_admin,
                    financial_reason: cashback_reason,
                    cent_amount: amount_to_cashback,
                    moneyflow: :credit,
                    note: I18n.t(:third_party_payment,
                                 order_id: @order.hashid,
                                 beneficiary: @order.user.username))
    end
  end
end
