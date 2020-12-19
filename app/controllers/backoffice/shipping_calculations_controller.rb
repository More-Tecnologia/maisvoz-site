module Backoffice
  class ShippingCalculationsController < BackofficeController
    include ActionView::Helpers::NumberHelper

    def new
      order = Shopping::UpdateCartTotals.call(current_order, params[:country])

      render json: { total: number_to_currency(order.total_cents / 100.0),
                     shipping: number_to_currency(order.shipping_cents / 100.0) }
    end
  end
end
