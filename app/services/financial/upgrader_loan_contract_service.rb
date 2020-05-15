module Financial
  class UpgraderLoanContractService < ApplicationService
    def call
      return unless @bonus_contract
      upgrade_loan_contract_to_rentability_contract if user_paid_loan_contract?
    end

    private

    def initialize(args)
      @user = args[:user]
      @rentability_days_count = BonusContract::RENTABILITY_DAYS_COUNT
      @bonus_contract = @user.bonus_contracts
                             .current_loan
    end

    def user_paid_loan_contract?
      @user.available_balance >= @bonus_contract.cent_amount
    end

    def upgrade_loan_contract_to_rentability_contract
      @bonus_contract.cent_amount = 2 * @bonus_contract.cent_amount.to_f.abs
      @bonus_contract.rentability = (@bonus_contract.cent_amount / @rentability_days_count).round(2)
      @bonus_contract.remaining_balance = @bonus_contract.cent_amount - @bonus_contract.received_balance
      @bonus_contract.expire_at = @rentability_days_count.days.from_now
      @bonus_contract.loan = false
      @bonus_contract.inactived_loan_at = DateTime.current
      @bonus_contract.save!
    end
  end
end
