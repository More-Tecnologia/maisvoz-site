module Bonification
  class CreatorYieldService < ApplicationService
    def call
      yield_contracts.find_each do |contract|
        create_yield_bonus_for(contract) if contract.rentability.positive?
      end
    end

    private

    def yield_contracts
      BonusContract.includes(:user)
                   .active
                   .yield_contracts
    end

    def create_yield_bonus_for(contract)
      user = contract.user
      user.financial_transactions
          .create!(spreader: User.find_morenwm_customer_admin,
                   financial_reason: FinancialReason.yield_bonus,
                   moneyflow: :credit,
                   cent_amount: contract.rentability,
                   bonus_contract: contract)
    end
  end
end
