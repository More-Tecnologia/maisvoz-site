module Bonification
  class CreatorPoolPointService < ApplicationService

    def call
      cent_amount = calculate_order_pool_point
      @user.scores.create!(order: @order,
                           spreader_user: @user,
                           score_type: ScoreType.pool_point,
                           cent_amount: cent_amount,
                           expire_at: 1.year.from_now) if cent_amount > 0
    end

    private

    def initialize(args)
      @order = args[:order]
      @user = @order.user
    end

    def calculate_order_pool_point
      items = @order.order_items.select { |i| i.product.generate_pool_points }
      items.sum { |i| i.quantity * i.product.binary_score }
    end

  end
end
