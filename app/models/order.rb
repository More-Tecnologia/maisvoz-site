# == Schema Information
#
# Table name: orders
#
#  id             :integer          not null, primary key
#  user_id        :integer
#  subtotal_cents :integer          default("0")
#  tax_cents      :integer          default("0")
#  shipping_cents :integer          default("0")
#  total_cents    :integer          default("0")
#  status         :integer          default("0")
#  payment_status :integer          default("0")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  paid_at        :datetime
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#

class Order < ApplicationRecord

  enum status: { open: 0, pending_payment: 1, processing: 2, completed: 3, cancelled: 4 }
  enum payment_status: { pending: 0, paid: 2, expired: 3 }

  has_many :order_items
  has_many :pv_histories
  has_one :pv_activity_history
  belongs_to :user

  monetize :subtotal_cents
  monetize :tax_cents
  monetize :shipping_cents
  monetize :total_cents

  scope :today, -> { where('created_at >= ?', Time.zone.now.beginning_of_day)}

  ransacker :date_paid_at do
    Arel.sql("DATE(#{table_name}.paid_at)")
  end

end
