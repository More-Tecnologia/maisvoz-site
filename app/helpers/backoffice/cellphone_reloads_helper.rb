require 'csv'

module Backoffice
  module CellphoneReloadsHelper

    def cellphone_products_for_select
      reload_products = Product.cellphone_reloads
      reload_products.map { |p| [format_reload_product_label(p), p.id] }
    end

    def format_reload_product_label(product)
      product_value = number_to_currency(product.product_value)
      product.activation? ? t('defaults.activation', product_value: product_value) : product_value
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
                                  cellphone_number: cellphone_reload.cellphone_number_normalized,
                                  quantity: 1,
                                  unit_price_cents: cellphone_reload.product.price_cents,
                                  total_cents: cellphone_reload.product.price_cents)
        order
      end
    end

    def find_cellphone_reloads_to_html(q)
      q.result.includes(order: [:user])
               .cellphone_reloads
               .where(order: Order.completed.paid)
               .page(params[:page])
    end

    def find_cellphone_reloads_to_csv(q)
      q.result.includes(order: [:user])
               .cellphone_reloads
               .where(order: Order.completed.paid)
    end

    def render_reloads_as_csv(reloads)
      text = CSV.generate(col_sep: ';') do |csv|
               csv << build_reload_csv_header
               reloads.each do |reload|
                 csv << format_reload_to_csv(reload)
               end
             end
      send_reloads_by_csv_file(text)
    end

    private

    def build_reload_csv_header
      [OrderItem.human_attribute_name(:item),
       CellphoneReloadForm.human_attribute_name(:value),
       CellphoneReloadForm.human_attribute_name(:created_at),
       CellphoneReloadForm.human_attribute_name(:cellphone_number),
       OrderItem.human_attribute_name(:user),
       OrderItem.human_attribute_name(:order_id),
       OrderItem.human_attribute_name(:processed_at)]
    end

    def format_reload_to_csv(reload)
      [reload.try(:hashid),
       reload.value,
       reload.created_at ? reload.created_at.strftime("%d/%m/%Y") : '',
       reload.cellphone_number,
       reload.try(:order).try(:user).try(:username),
       reload.try(:order).try(:hashid),
       reload.processed_at ? reload.processed_at.strftime("%d/%m/%Y") : ''
     ]
    end

    def send_reloads_by_csv_file(text)
      send_data text, type: "text/csv",
                      disposition: 'inline',
                      filename: t('defaults.reloads_csv_filename', datetime: Date.current.to_s)
    end

  end
end
