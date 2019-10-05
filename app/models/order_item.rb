# == Schema Information
#
# Table name: order_items
#
#  id               :bigint(8)        not null, primary key
#  quantity         :integer          default(0)
#  unit_price_cents :integer          default(0)
#  total_cents      :integer          default(0)
#  order_id         :bigint(8)
#  product_id       :bigint(8)
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#
# Indexes
#
#  index_order_items_on_order_id    (order_id)
#  index_order_items_on_product_id  (product_id)
#

class OrderItem < ApplicationRecord

  delegate :name, :adhesion?, to: :product
  delegate :system_taxable?, to: :product

  belongs_to :order
  belongs_to :product

  monetize :unit_price_cents
  monetize :total_cents

end
