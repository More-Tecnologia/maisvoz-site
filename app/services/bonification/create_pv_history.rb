module Bonification
  class CreatePvHistory

    prepend SimpleCommand

    def initialize(direction, user, order, score)
      @direction = direction
      @user      = user
      @order     = order
      @score     = score
    end

    def call
      PvHistory.create!(
        direction: direction,
        user: user,
        order: order,
        origin_username: origin_username,
        amount: score,
        balance: final_balance
      )
    end

    private

    attr_reader :direction, :user, :order, :score

    def final_balance
      last_balance + score
    end

    def last_balance
      return 0 if last_pv_history.blank?
      last_pv_history
    end

    def last_pv_history
      @last_pv_history ||= user.binary_node.send(leg_pv)
    end

    def leg_pv
      direction == :left ? :left_pv : :right_pv
    end

    def origin_username
      return if order.blank?
      order.user.username
    end

  end
end
