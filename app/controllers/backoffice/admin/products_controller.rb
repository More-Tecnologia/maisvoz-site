module Backoffice
  module Admin
    class ProductsController < EcommerceController
      before_action :find_product, only: %i[edit update destroy]

      def index
        @products = Product.order(:id)
                           .page(params[:page])
      end

      def new
        @product = Product.new
      end

      def edit; end

      def create
        @product = Product.new(valid_params)
        if @product.save
          flash[:success] = t('defaults.saving_success')
          redirect_to backoffice_admin_products_path(@product)
        else
          flash[:error] = @product.errors.full_messages.join(', ')
          render :new
        end
      end

      def update
        if @product.update(valid_params)
          flash[:success] = t('defaults.saving_success')
          redirect_to backoffice_admin_products_path
        else
          flash[:error] = @product.errors.full_messages.join(', ')
          render :edit
        end
      end

      def destroy
        if @product.update(active: false)
          flash[:success] = t('defaults.destroying_success')
        else
          flash[:error] = t('defaults.destroying_error')
        end
        redirect_to backoffice_admin_products_path
      end

      private

      def find_product
        @product = Product.find(params[:id])
      end

      def valid_params
        params.require(:product)
              .permit(:name, :description, :short_description, :sku, :quantity,
                      :kind, :low_stock_alert, :weight, :length, :width, :height,
                      :price_cents, :binary_score, :advance_score, :active, :virtual,
                      :paid_by, :binary_bonus, :main_photo, :category_id,
                      :system_taxable, :shipping, :dropship_link, :details,
                      product_descriptions_attributes: [:id, :photo, :description, :position],
                      photos: [])
      end
    end
  end
end
