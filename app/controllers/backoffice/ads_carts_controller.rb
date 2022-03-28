# frozen_string_literal: true

module Backoffice
  class AdsCartsController < BackofficeController
    def show
      redirect_to ads_backoffice_stores_path unless current_ads_cart.order_items.any?
    end

    def destroy
      current_ads_cart.order_items.find(params[:order_item_id]).destroy
      Shopping::UpdateCartTotals.call(current_ads_cart, params[:country])
      flash[:success] = t(:removed_successfully)

      redirect_to backoffice_ads_carts_path
    end

    private

    def product_params
      params.require(:product).permit(:id)
    end
  end
end
