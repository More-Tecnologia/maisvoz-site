module Subscriptions
  class Compensate

    def initialize(order:)
      @order = order
    end

    def call
      if order.clubmotors_adhesion?
        Subscriptions::ActivateClubMotors.new(order: order).call
      elsif order.monthly_fee?
        Subscriptions::PayMonthlyFee.new(order: order).call
      end
    end

    private

    attr_reader :order

  end
end