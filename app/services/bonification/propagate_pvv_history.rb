module Bonification
  class PropagatePvvHistory

    def initialize(order)
      @order = order
      @user = order.user
    end

    def call
      return unless total_score > 0
      if user.empreendedor?
        propagate_pv_activity(order.user, 'pvv')
      else
        propagate_pv_activity(order.user.sponsor, 'pvv')
      end
    end

    private

    attr_reader :order, :user

    def propagate_pv_activity(user, kind)
      height = 0
      while user.present?
        height += 1
        create_pv_activity(user, kind, height)
        user.increment!(:pva_total, total_score)
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
      @total_score ||= order.total_score
    end

  end
end
