module Financial
  class UpgraderLoanContractService < ApplicationService
    def call
      return unless @loan_bonus_contract
      upgrade_loan_contract_to_rentability_contract if user_paid_loan_contract?
    end

    private

    def initialize(args)
      @user = args[:user]
      @rentability_days_count = BonusContract::RENTABILITY_DAYS_COUNT
      @loan_bonus_contract = @user.current_loan_contract
    end

    def user_paid_loan_contract?
      user_yield_bonus = @user.financial_transactions
                              .to_empreendedor
                              .yield_bonus
                              .sum(:cent_amount) / 1e8.0
      @user.available_balance - user_yield_bonus >= @loan_bonus_contract.cent_amount
    end

    def upgrade_loan_contract_to_rentability_contract
      @loan_bonus_contract.cent_amount = 2 * @loan_bonus_contract.cent_amount.to_f.abs
      @loan_bonus_contract.rentability = (@loan_bonus_contract.cent_amount / @rentability_days_count).round(2)
      @loan_bonus_contract.remaining_balance = @loan_bonus_contract.cent_amount - @loan_bonus_contract.received_balance
      @loan_bonus_contract.expire_at = @rentability_days_count.days.from_now
      @loan_bonus_contract.loan = false
      @loan_bonus_contract.inactived_loan_at = DateTime.current
      @loan_bonus_contract.save!
    end
  end
end
