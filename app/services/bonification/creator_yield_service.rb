module Bonification
  class CreatorYieldService < ApplicationService
    def call
      errors = []
      yield_contracts.find_each do |contract|
        create_yield_bonus_for(contract) if contract.rentability.positive?
      rescue StandardError => error
        errors << error
      end
      notify_admin_by_email(errors) if errors.any?
    end

    private

    NON_QUALIFIED_USER_RENTABILITY = 0.03
    VALID_CONTRACTS_MINIMUM_QUANTITY = 4.freeze

    def yield_contracts
      BonusContract.includes(:order, user: [sponsored: [:bonus_contracts]])
                   .active
                   .yield_contracts
    end

    def create_yield_bonus_for(contract)
      user = contract.user
      user.financial_transactions
          .create!(spreader: User.find_morenwm_customer_admin,
                   financial_reason: FinancialReason.yield_bonus,
                   moneyflow: :credit,
                   cent_amount: (contract.cent_amount / 2.0) * rentability_by_contract(contract),
                   bonus_contract: contract,
                   order: contract.order)
    end

    def rentability_by_contract(contract)
      return contract.rentability if user_qualified?(contract)

      NON_QUALIFIED_USER_RENTABILITY
    end

    def user_qualified?(contract)
      contract_value = contract.cent_amount

      sponsored_contracts = contract.user
                                    .sponsored
                                    .map { |s| s.bonus_contracts }
                                    .flatten
      valid_contracts_quantity = sponsored_contracts.count { |c| c.cent_amount >= contract_value }
      valid_contracts_quantity >= VALID_CONTRACTS_MINIMUM_QUANTITY
    end

    def notify_admin_by_email(errors)
      subject = "Yield Bonus Errors: #{errors.size}"
      ErrorsMailer.notify_admin(subject, errors).deliver_later
    end
  end
end
