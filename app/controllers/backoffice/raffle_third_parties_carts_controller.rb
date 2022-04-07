# frozen_string_literal: true

module Backoffice
  class RaffleThirdPartiesCartsController < BackofficeController
    def show
      @q = Order.includes(:product)
                .ransack(params)
      @order = @q.result
                 .first
    end
  end
end
