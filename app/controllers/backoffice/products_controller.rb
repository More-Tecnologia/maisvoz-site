module Backoffice
  class ProductsController < BackofficeController
    before_action :ensure_user_consumidor, only: :show
    before_action :redirect_back_if_deposit_product, only: :show

    def index
      @products = Product.deposit.active.order(:price_cents)
      @banner = Product.deposit.active.limit(4)
    end

    def show
      render(:show, locals: { product: product })
    end

    private

    def product
      @product ||= Product.find(params[:id])
    end

    def ensure_user_consumidor
      flash[:notice] = 'You need to be a consumer to purchase the membership package'
      redirect_back fallback_location: root_path if current_user.empreendedor? && product.adhesion?
    end

    def redirect_back_if_deposit_product
      redirect_back(fallback_location: root_path) if product.try(:deposit?)
    end
  end
end
