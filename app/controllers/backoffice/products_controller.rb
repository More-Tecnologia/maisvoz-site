module Backoffice
  class ProductsController < BackofficeController

    def index
      @products = Product.active
    end

    def show
      @product = Product.find(params[:id])
    end
  end

end
