class CreatorBonusContractService < ApplicationService

  def call
    @user.bonus_contracts.create!(order: @order,
                                  cent_amount: three_times_order_value,
                                  remaining_balance: three_times_order_value,
                                  received_balance: 0,
                                  expire_at: 1.year.from_now)
  end

  private

  def initialize(args)
    @order = args[:order]
    @user = @order.user
  end

  def three_times_order_value
    @order.total_value * 2
  end

end
