# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  subtotal_cents :integer          default(0)
#  tax_cents      :integer          default(0)
#  shipping_cents :integer          default(0)
#  total_cents    :integer          default(0)
#  status         :integer          default("cart")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  paid_at        :datetime
#  pv_total       :integer          default(0), not null
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#

class Order < ApplicationRecord

  include Hashid::Rails

  enum status: { cart: 0, pending_payment: 1, processing: 2, completed: 3, cancelled: 4 }

  has_many :order_items, dependent: :destroy
  has_many :pv_histories
  has_many :bonus, class_name: 'Bonus'
  has_many :pv_activity_histories
  has_many :pagarme_transactions
  belongs_to :user

  monetize :subtotal_cents
  monetize :tax_cents
  monetize :shipping_cents
  monetize :total_cents

  scope :today, -> { where('created_at >= ?', Time.zone.now.beginning_of_day)}

  ransacker :date_paid_at do
    Arel.sql("DATE(#{table_name}.paid_at)")
  end

  def total_score
    @total_score ||= order_items.sum { |item| item.quantity * item.product.binary_score }
  end

  def max_product_score
    @max_product_score ||= order_items.map { |item| item.product.binary_score }.max
  end

  def current_transaction
    return unless pagarme_transactions
    pagarme_transactions.paid.first || pagarme_transactions.order(:created_at).last
  end

end
