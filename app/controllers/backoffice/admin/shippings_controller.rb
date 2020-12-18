module Backoffice::Admin
  class ShippingsController < AdminController
    before_action :find_product
    before_action :find_shipping, only: %i[edit update destroy]

    def new
      @shipping = Shipping.new
    end

    def create
      @shipping = @product.shippings.build(valid_params)
    end

    def edit; end

    def update; end

    def destroy
      @shipping.destroy!
    end

    private

    def find_product
      @product = Product.find(params[:product_id])
    end

    def find_shipping
      @shipping = @product.shippings.find(params[:id])
    end

    def valid_params
      params.require(:shipping)
            .permit(:amount, :country)
    end
  end
end
