module Backoffice
  class AdhesionProductsController < BackofficeController
    def index
      @products = Product.deposit
                         .order(:price_cents)
    end
  end
end
