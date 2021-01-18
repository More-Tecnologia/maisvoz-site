module Backoffice
  module Admin
    class ProductDescriptionsController < EcommerceController
      before_action :find_product_description, only: %i[edit update]

      def new
        @product_description = ProductDescription.new
      end

      def edit; end

      def create
        @product_description = ProductDescription.new(valid_params)
        if @product_description.save
          flash[:success] = t('defaults.saving_success')
        else
          flash[:error] = @product_description.errors.full_messages.join(', ')
        end
      end

      def update
        if @product_description.update(valid_params)
          flash[:success] = t('defaults.saving_success')
        else
          flash[:error] = @product_description.errors.full_messages.join(', ')
        end
      end

      def destroy
        if @product_description.update(active: false)
          flash[:success] = t('defaults.destroying_success')
        else
          flash[:error] = t('defaults.destroying_error')
        end
      end

      private

      # def find_product_description
      #   @product_description = ProductDescription.find(params[:id])
      # end

      def valid_params
        params.require(:product_description)
              .permit(:photo, :description, :position)
      end
    end
  end
end
