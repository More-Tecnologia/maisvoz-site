module Bonification
  class PropagatePvvHistory

    def initialize(order)
      @order = order
    end

    def call
      return if total_score <= 0
      propagate_pv_activity(order.user, 'pvv')
    end

    private

    attr_reader :order

    def propagate_pv_activity(user, kind)
      height = 0
      while user.present?
        create_pv_activity(user, kind, height)
        height += 1
        user = user.sponsor
      end
    end

    def create_pv_activity(user, kind, height)
      PvActivityHistory.create!(
        order:   order,
        user:    user,
        amount:  total_score,
        balance: user.pva_total + total_score,
        kind:    kind,
        height:  height
      )
    end

    def total_score
      @total_score ||= order.pvv_score
    end

  end
end
