class CreatorBonusContractService < ApplicationService
  def call
    if @deposit_value < 100
      expire_at = 180.days.from_now
      contract_value = 2 * @deposit_value
      rentability = contract_value / 180.0

      create_bonus_contract_for_order_user(contract_value, expire_at, rentability)
    else
      expire_at = 1.year.from_now
      contract_value = 2 * @deposit_value
      rentability = contract_value / 365.0

      create_bonus_contract_for_order_user(contract_value, expire_at, rentability)
    end
  end

  private

  def initialize(args)
    @order = args[:order]
    @user = @order.user
    @deposit_value = @order.total_value
  end

  def create_bonus_contract_for_order_user(contract_value, expire_at, rentability, loan = false)
    @user.bonus_contracts
         .create!(order: @order,
                  cent_amount: contract_value.round(2),
                  remaining_balance: contract_value.round(2),
                  received_balance: 0,
                  expire_at: expire_at,
                  rentability: rentability.round(2),
                  loan: loan)
  end

  def debit_contract_value_from_user_balance(contract_value)
    @user.financial_transactions
         .create!(spreader: User.find_morenwm_customer_admin,
                  financial_reason: FinancialReason.deposit_less_than_fifty,
                  cent_amount: contract_value,
                  order: @order,
                  moneyflow: :debit)
  end
end
