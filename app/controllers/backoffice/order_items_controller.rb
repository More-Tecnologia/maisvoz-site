module Backoffice
  class OrderItemsController < BackofficeController

    def create
      command = Shopping::AddToCart.call(current_order, product_params[:id])
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
      order_item.update!(quantity: order_item_params[:quantity].to_i.abs)
      update_order_total
      flash[:success] = I18n.t('cart.cart_updated')
      redirect_to backoffice_cart_path
    end

    def destroy
      order_item = OrderItem.find(params[:id])
      order_item.destroy!
      update_order_total
      flash[:success] = I18n.t('cart.cart_updated')
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

  end
end
