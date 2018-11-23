module Bonification
  class PropagatePvmPoints

    def initialize(order:)
      @order = order
    end

    def call
      return if !order.monthly_fee? || total_score <= 0

      propagate_pv_activity(order.user, 'pvm')
    end

    private

    attr_reader :order

    def propagate_pv_activity(user, kind)
      height = 0
      while user.present?
        break if height == 7

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
      order.pvm_score
    end

  end
end
