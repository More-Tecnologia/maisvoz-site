module Backoffice
  module Admin
    class ProductsController < AdminController

      def index
        @products = Product.all.order(:id)
      end

      def new
        render_new
      end

      def edit
        render_edit
      end

      def create
        if CreateProduct.new(form).call
          flash[:success] = I18n.t('defaults.saving_success')
          redirect_to backoffice_admin_products_path
        else
          flash[:error] = I18n.t('defaults.saving_error')
          render_new
        end
      end

      def update
        if UpdateProduct.new(form, product).call
          flash[:success] = I18n.t('defaults.saving_success')
          redirect_to backoffice_admin_products_path
        else
          flash[:error] = I18n.t('defaults.saving_error')
          render_edit
        end
      end

      def destroy
        if DestroyProduct.new(product).call
          flash[:success] = I18n.t('defaults.destroying_success')
        else
          flash[:error] = I18n.t('defaults.destroying_error')
        end
        redirect_to backoffice_admin_products_path
      end

      private

      def render_new
        render(:new, locals: { form: form })
      end

      def render_edit
        render(:edit, locals: { form: form, product: product })
      end

      def product
        @product ||= Product.find(params[:id])
      end

      def form
        @form ||= ProductForm.new(product_params)
      end

      def product_params
        if params[:id].present?
          params[:product_form] ||= product.attributes
          params[:product_form][:id] ||= product.id
          params[:product_form][:price] ||= product.price
          params[:product_form][:public_id] ||= product.image
        end
        params.fetch(:product_form, {}).permit!
      end

    end
  end
end
