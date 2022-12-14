module Backoffice
  class ProductsController < BackofficeController
    skip_before_action :authenticate_user!, only: :index
    before_action :ensure_user_consumidor, only: :show
    before_action :redirect_back_if_deposit_product, only: :show

    def index
      @products = Product.where(kind: [:deposit, :free]).active.order(:price_cents)
      #TODO: Create a query to get the product one level uper than the current sined by the user 
      @banner = Product.deposit.active.shuffle[0..4]
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
