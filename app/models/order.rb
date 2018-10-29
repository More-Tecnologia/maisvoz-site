# == Schema Information
#
# Table name: orders
#
#  id             :bigint(8)        not null, primary key
#  user_id        :bigint(8)
#  subtotal_cents :integer          default(0)
#  tax_cents      :integer          default(0)
#  shipping_cents :integer          default(0)
#  total_cents    :integer          default(0)
#  status         :integer          default("cart")
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  paid_at        :datetime
#  pv_total       :bigint(8)        default(0), not null
#  sap_recorded   :boolean          default(FALSE)
#  sap_response   :text
#
# Indexes
#
#  index_orders_on_user_id  (user_id)
#

class Order < ApplicationRecord

  serialize :sap_response, JSON

  include Hashid::Rails

  enum status: { cart: 0, pending_payment: 1, processing: 2, completed: 3, cancelled: 4 }

  has_many :order_items, dependent: :destroy
  has_many :pv_histories
  has_many :bonus, class_name: 'Bonus'
  has_many :pv_activity_histories
  has_many :payment_transactions
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
    return if completed? || payment_transactions.blank?

    payment_transactions.any?(&:paid?) || payment_transactions.order(:created_at).last
  end

  def adhesion_product
    @adhesion_product ||= order_items.joins(:product).where('products.kind = ?', Product.kinds[:adhesion]).first.try(:product)
  end

  def club_motors_product
    @club_motors_product ||= order_items.joins(:product).where('products.club_motors = true').first.try(:product)
  end

  def pvg_score
    @pvg_score ||= order_items.joins(:product).where(
      'products.kind = ?', Product.kinds[:adhesion]
    ).sum(:binary_score)
  end

  def pvv_score
    @pvv_score ||= order_items.joins(:product).where(
      'products.kind != ?', Product.kinds[:adhesion]
    ).sum(:binary_score)
  end

  def token
    Digest::MD5.hexdigest("#{id * 1337}:#{hashid}")
  end

end
