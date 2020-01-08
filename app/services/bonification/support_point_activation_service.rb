module Bonification
  class SupportPointActivationService < ApplicationService

    FEE = 0.04.to_f.freeze

    def call
      return unless user.support_point?
      financial_transaction =
        user.financial_transactions.create!(order: order,
                                            spreader: order.try(:user),
                                            financial_reason: financial_reason,
                                            cent_amount: bonus_value) if bonus_value > 0
      chargeback_by_inactivity!(financial_transaction) if user.inactive?
    end

    private

    attr_accessor :order, :financial_reason, :user, :bonus_value

    def initialize(args)
      @order = args[:order]
      @user = order.try(:user).try(:support_point_user)
      @financial_reason = FinancialReason.support_point_activation_bonus
      @bonus_value = calculate_bonus_value
    end

    def chargeback_by_inactivity!(financial_transaction)
      reason = financial_reason.chargeback_by_inactivity
      financial_transaction.chargeback_by_inactivity!(reason)
    end

    def calculate_bonus_value
      product_value = order.try(:activation_product).try(:product_value).to_f
      product_value * FEE
    end

  end
end
