module Backoffice
  class ProductCheckoutsController < EntrepreneurController
    def new
      @product = Product.find(params[:product_id])
    end

    def create
      ActiveRecord::Base.transaction do
        @payment_transaction = Payment::BlockCheckoutService.call(order: order)
        render 'backoffice/payment_transactions/show'
      end
    rescue StandardError => error
      flash[:error] = error.message
      redirect_back(fallback_location: root_path)
    end

    private

    def order
      product = Product.find(params[:product_id])
      item = { product: product,
               quantity: 1,
               total_cents: product.price_cents,
               unit_price_cents: product.price_cents }

      current_user.orders
                  .create!(total_cents: product.price_cents,
                           subtotal_cents: product.price_cents,
                           status: :pending_payment,
                           payment_type: :btc,
                           expire_at: 3.days.from_now,
                           order_items_attributes: [item])
    end
  end
end
