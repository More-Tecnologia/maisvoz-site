module Backoffice
  class CartsController < BackofficeController
    def show
      @order = current_order
    end
  end
end
