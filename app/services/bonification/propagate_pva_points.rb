module Bonification
  class PropagatePvaPoints

    def initialize(order:)
      @order = order
    end

    def call
      user = order.user
      while user.present?
        user.increment!(:pva_total, total_score)
        user = user.sponsor
      end
    end

    private

    attr_reader :order

    delegate :total_score, to: :order

  end
end
