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
                   cent_amount: contract.cent_amount * contract.rentability,
                   bonus_contract: contract)
    end

    def notify_admin_by_email(errors)
      subject = "Yield Bonus Errors: #{errors.size}"
      ErrorsMailer.notify_admin(subject, errors).deliver_later
    end
  end
end
