module Subscriptions
  class Compensate

    def initialize(order:)
      @order = order
    end

    def call
      if order.monthly_fee?
        Subscriptions::PayMonthlyFee.new(order: order).call
      end
    end

    private

    attr_reader :order

  end
end
