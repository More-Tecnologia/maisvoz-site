module Bonification
  class CreatePvActivityHistory

    def initialize(order)
      @order = order
    end

    def call
      if user.empreendedor?
        create_pv_activity(user)
      else
        create_pv_activity(user.sponsor)
      end
    end

    private

    attr_reader :order

    delegate :user, to: :order

    def create_pv_activity(user)
      PvActivityHistory.create!(
        order: order,
        user: user,
        amount: total_score
      )
    end

    def total_score
      @total_score ||= order.order_items.sum { |item| item.quantity * item.product.binary_score }
    end

  end
end
