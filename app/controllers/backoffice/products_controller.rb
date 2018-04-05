module Backoffice
  class ProductsController < BackofficeController

    before_action :ensure_user_consumidor, only: :show

    def index
      render(:index, locals: { products: products, q: q })
    end

    def show
      render(:show, locals: { product: product })
    end

    private

    def products
      @products ||= q.result.page(params[:page])
    end

    def q
      if current_user.consumidor?
        @q ||= Product.active.order(:price_cents).includes(:photo_files, :main_photo_files).ransack(params[:q])
      else
        @q ||= Product.active.order(:price_cents).includes(:photo_files, :main_photo_files).where.not(kind: :adhesion).ransack(params[:q])
      end
    end

    def product
      @product ||= Product.find(params[:id])
    end

    def ensure_user_consumidor
      flash[:notice] = 'Você precisa ser um consumidor para comprar o pacote de adesão'
      redirect_back fallback_location: root_path if current_user.empreendedor? && product.adhesion?
    end

  end
end
