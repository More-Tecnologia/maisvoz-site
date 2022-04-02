module Backoffice
  class OrderItemsController < BackofficeController

    def create
      clean_shopping_cart
      clean_ads_cart
      clean_courses_cart
      clean_raffles_cart
      command = Shopping::AddToCart.call(current_order, product_params[:id], params[:country])
      if command.success?
        session[:order_id] = command.result.id
      else
        flash[:error] = t(command.errors)
      end
      redirect_to backoffice_cart_path
    end

    def update
      order = current_order
      order_item = order.order_items.find(order_item_params[:id])
      order_item.update!(quantity: order_item_params[:quantity].to_i.abs) unless order_item.adhesion?
      update_order_total
      update_order_pv_total
      flash[:success] = t('.cart_updated')
      redirect_to backoffice_cart_path
    end

    def destroy
      order_item = OrderItem.find(params[:id])
      order_item.destroy!
      update_order_total
      flash[:success] = t('.cart_updated')
      redirect_to backoffice_cart_path
    end

    private

    def product_params
      params.require(:product).permit(:id)
    end

    def order_item_params
      params.require(:order_item).permit(:id, :quantity)
    end

    def update_order_total
      Shopping::UpdateCartTotals.call(current_order)
    end

    def update_order_pv_total
      current_order.update!(pv_total: current_order.total_score)
    end

    def ensure_valid_product
      return unless current_user.active? && product.adhesion? && product_less_or_equal_current_trail_product?
      flash[:error] = I18n.t('defaults.cant_buy_product')
      redirect_back fallback_location: root_path
    end

    def product_less_or_equal_current_trail_product?
      trail_product = current_user.try(:current_trail).try(:product)
      trail_product && product.price_cents <= trail_product.price_cents
    end

    def product
      @product ||= Product.find_by_hashid(params[:product][:id])
    end

  end
end
