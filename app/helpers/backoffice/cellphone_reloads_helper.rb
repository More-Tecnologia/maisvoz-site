module Backoffice
  module CellphoneReloadsHelper

    def cellphone_products_for_select
      reload_products = Product.cellphone_reloads
      reload_products.map { |p| [number_to_currency(p.product_value), p.id] }
    end

    def available_ddds
      [11, 12, 13, 14, 15, 16, 17, 18, 19, 21, 22, 24, 27, 28, 31, 32, 33, 34,
       35, 37, 38, 41, 42, 43, 44, 45, 46, 47, 48, 49, 51, 53, 54, 55, 61, 62,
       63, 64, 65, 66, 67, 68, 69, 71, 73, 74, 75, 77, 79, 81, 82, 83, 84, 85,
       86, 87, 88, 89, 91, 92, 93, 94, 95, 96, 97, 98, 99]
    end

    def create_reload_order(cellphone_reload)
      ActiveRecord::Base.transaction do
        order = current_user.orders.create!(total_cents: cellphone_reload.product.price_cents,
                                           status: Order.statuses[:pending_payment])
        order.order_items.create!(product: cellphone_reload.product,
                                  cellphone_number: cellphone_reload.cellphone_number,
                                  quantity: 1,
                                  unit_price_cents: cellphone_reload.product.price_cents,
                                  total_cents: cellphone_reload.product.price_cents)
        order
      end
    end

  end
end
