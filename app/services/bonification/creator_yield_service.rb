module Bonification
  class CreatorYieldService < ApplicationService
    def call
      errors = []
      yield_contracts.find_each do |contract|
        create_yield_bonus_for(contract)
      rescue StandardError => error
        errors << error
      end
      notify_admin_by_email(errors) if errors.any?
    end

    private

    def yield_contracts
      BonusContract.includes(:order, user: [sponsored: [:bonus_contracts]])
                   .active
                   .yield_contracts
                   .enabled_bonification
    end

    def create_yield_bonus_for(contract)
      user = contract.user
      cent_amount = (contract.cent_amount / 2.0) * rentability_by_contract(contract)

      user.financial_transactions
          .create!(spreader: User.find_morenwm_customer_admin,
                   financial_reason: FinancialReason.yield_bonus,
                   moneyflow: :credit,
                   cent_amount: cent_amount,
                   bonus_contract: contract,
                   order: contract.order) if cent_amount.positive?
    end

    def rentability_by_contract(contract)
      contract.user.type.bonus_percentage / 100.0
    end

    def notify_admin_by_email(errors)
      subject = "Yield Bonus Errors: #{errors.size}"
      ErrorsMailer.notify_admin(subject, errors).deliver_later
    end
  end
end
