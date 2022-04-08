# frozen_string_literal: true

module Backoffice
  class RaffleThirdPartiesCartsController < BackofficeController
    def show
      @q = Order.includes(order_items: :product)
                .ransack(params)
      @order = @q.result
                 .first
    end
  end
end
