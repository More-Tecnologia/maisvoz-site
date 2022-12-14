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
          create_product_reason_score
          flash[:success] = t('defaults.saving_success')
          redirect_to backoffice_admin_products_path(@product)
        else
          flash[:error] = @product.errors.full_messages.join(', ')
          render :new
        end
      end

      def update
        if @product.update(valid_params)
          create_product_reason_score
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

      def delete_photo_attachment
        photo = ActiveStorage::Attachment.find(params[:id])
        photo.purge
        redirect_back(fallback_location: request.referer)
      end

      def delete_product_description
        ProductDescription.find(params[:id]).delete
        redirect_back(fallback_location: request.referer)
      end

      private

      def find_product
        @product = Product.find(params[:id])
      end

      def create_product_reason_score
        referral_bonus = [[000]]
        (Career.count - 1).times do
          referral_bonus.first << @product.direct_indication_bonus.to_i * 100
        end

        Scores::CreatorProductReasonScoreService.call(products: [@product],
                                                      reason: FinancialReason.direct_commission_bonus,
                                                      referral_bonus: referral_bonus,
                                                      fix_value: !@product.direct_indication_bonus_in_percentage)
      end

      def valid_params
        params.require(:product)
              .permit(:name, :description, :short_description, :sku, :quantity,
                      :kind, :low_stock_alert, :weight, :length, :width, :height,
                      :price_cents, :binary_score, :advance_score, :active, :virtual,
                      :paid_by, :binary_bonus, :main_photo, :category_id,
                      :system_taxable, :shipping, :dropship_link, :details,
                      :task_per_day, :earnings_per_campaign,
                      :direct_indication_bonus, :direct_indication_bonus_in_percentage,
                      product_descriptions_attributes: [:id, :photo, :description, :position],
                      photos: [])
      end
    end
  end
end
