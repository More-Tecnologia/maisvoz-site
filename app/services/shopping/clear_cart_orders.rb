module Shopping
  class ClearCartOrders

    def call()
      ActiveRecord::Base.transaction do
        Order.cart.where('created_at < ?', 1.day.ago).destroy_all
      end
    end

  end
end
