module Bonification
  class ClickcashCreatorService < ApplicationService
    def call
      return if first_active_bonus_contract.blank?
      create_clickcash_bonus_for_user
    end

    private

    def initialize(args)
      @user = args[:user]
    end

    def first_active_bonus_contract
      @bonus_contract ||= @user.bonus_contracts
                               .active
                               .yield_contracts
                               .enabled_bonification
                               .first
    end

    def create_clickcash_bonus_for_user
      order_value = first_active_bonus_contract.order.total_cents / 100.0
      cent_amount = order_value * contract_rentability

      @user.financial_transactions
           .create!(spreader: User.find_morenwm_customer_admin,
                    financial_reason: FinancialReason.yield_bonus,
                    moneyflow: :credit,
                    cent_amount: cent_amount,
                    bonus_contract: first_active_bonus_contract,
                    order: first_active_bonus_contract.order) if cent_amount.positive?
    end

    def contract_rentability
      @user.type.bonus_percentage / 100.0
    end
  end
end
