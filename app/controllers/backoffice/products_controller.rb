module Backoffice
  class ProductsController < BackofficeController

    def index
      render(:index, locals: { products: products, q: q })
    end

    def show
      @product = Product.find(params[:id])
    end

    private

    def products
      @products ||= q.result.page(params[:page])
    end

    def q
      @q ||= Product.active.ransack(params[:q])
    end

  end
end
