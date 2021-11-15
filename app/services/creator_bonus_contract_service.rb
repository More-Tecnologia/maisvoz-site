class CreatorBonusContractService < ApplicationService
  def call
    expire_at = 3.months.from_now
    contract_value = @order.products.first == Product.first ? 25 : 1_000_000
    rentability = CONTRACT_RETABILITY

    create_bonus_contract_for_order_user(contract_value, expire_at, CONTRACT_RETABILITY)
  end

  private

  CONTRACT_FEE = 0.0.freeze
  CONTRACT_RETABILITY = 0.00.freeze

  def initialize(args)
    @order = args[:order]
    @user = @order.user
    @deposit_value = @order.total_value
    @enabled_bonification = args[:enabled_bonification]
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
end
