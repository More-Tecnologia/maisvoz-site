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
#  dr_recorded    :boolean          default(FALSE)
#  dr_response    :text
#  type           :string
#  expire_at      :date
#  payment_type   :string
#  paid_by        :string
#  payable_type   :string
#  payable_id     :bigint(8)
#  billed         :boolean          default(FALSE)
#
# Indexes
#
#  index_orders_on_payable_type_and_payable_id  (payable_type,payable_id)
#  index_orders_on_type                         (type)
#  index_orders_on_user_id                      (user_id)
#

class Order < ApplicationRecord

  include Hashid::Rails

  self.inheritance_column = nil

  serialize :dr_response, JSON

  enum status: { cart: 0, pending_payment: 1, processing: 2, completed: 3, expired: 4 }
  enum payment_type: { boleto: 'boleto', balance: 'balance', admin: 'admin' }

  has_many :order_items, dependent: :destroy
  has_many :pv_histories
  has_many :bonus, class_name: 'Bonus'
  has_many :pv_activity_histories
  has_many :payment_transactions
  has_many :scores
  has_many :financial_transactions

  belongs_to :user
  belongs_to :payable, polymorphic: true, optional: true

  monetize :subtotal_cents, :tax_cents, :shipping_cents, :total_cents

  scope :today, -> { where('created_at >= ?', Time.zone.now.beginning_of_day) }

  ransacker :date_paid_at do
    Arel.sql("DATE(#{table_name}.paid_at)")
  end

  def monthly_order_items
    return [] if payable.blank? || order_items.present?

    name = I18n.t(payable.type)
    product = OpenStruct.new(
      id: payable.id,
      hashid: payable.hashid,
      name: "#{name} (#{I18n.t('date.month_names')[created_at.month]}/#{created_at.year})"
    )

    [
      OpenStruct.new(
        product: product,
        quantity: 1,
        unit_price: total,
        total: total
      )
    ]
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
    @adhesion_product ||= products.select(&:adhesion?).first
  end

  def activation_product
    @activation_product ||= products.select(&:activation?).first
  end

  def club_motors_product
    @club_motors_product ||= order_items.joins(:product).where('products.club_motors = true').first.try(:product)
  end

  def token
    Digest::MD5.hexdigest("#{id * 1337}:#{hashid}")
  end

  def decorated_type
    if payable.present?
      "#{I18n.t(payable.type)} - #{I18n.t(type)}"
    else type.present?
      I18n.t(type)
    end
  end

  def products
    @products ||= order_items.includes(product: [:trail]).map(&:product)
  end

  def detached_products_score
    items = order_items.includes(:product).select { |item| item.product.detached? }
    items.sum { |item| item.quantity * item.product.binary_score }
  end

  def activation_products_score
    items = order_items.includes(:product).select { |item| item.product.activation? }
    items.sum { |item| item.quantity * item.product.binary_score }
  end

  def item_price_cents_sum
    order_items.sum { |item| item.quantity * item.product.price_cents }
  end

  def taxable_product_cent_amount
    order_items.sum { |i| i.system_taxable? ? i.product.price_cents : 0 }
  end
end
