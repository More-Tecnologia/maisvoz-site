module Shopping
  class ExpireOrderService < ApplicationService

    def call
      ActiveRecord::Base.transaction do
        @order.update(status: :expired) if @order.pending_payment?
      end
    end

    def initialize(order)
      @order = order
    end

  end
end
