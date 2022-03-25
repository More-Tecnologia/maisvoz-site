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

  FEE = 0.freeze

  self.inheritance_column = nil

  serialize :dr_response, JSON

  attr_accessor :loan_payment

  enum status: { cart: 0, pending_payment: 1, processing: 2, completed: 3, expired: 4 }
  enum payment_type: { balance: 'balance',
                       admin: 'admin',
                       voucher: 'voucher',
                       btc: 'btc',
                       admin_nb: 'admin_nb',
                       eth: 'eth',
                       usdt: 'usdt',
                       pix: 'pix',
                       free: 'free' }

  has_many :order_items, dependent: :destroy
  has_many :pv_histories
  has_many :bonus, class_name: 'Bonus'
  has_many :pv_activity_histories
  has_many :scores
  has_many :financial_transactions
  has_many :ads, class_name: 'Banner'

  has_one :payment_transaction
  has_one :bonus_contract
  has_one :address

  belongs_to :user
  belongs_to :payable, polymorphic: true, optional: true
  belongs_to :payer, class_name: 'User', optional: true

  accepts_nested_attributes_for :order_items

  monetize :subtotal_cents, :tax_cents, :shipping_cents, :total_cents

  scope :today, -> { where('created_at >= ?', Time.zone.now.beginning_of_day) }
  scope :valids, -> { where.not(status: %i[cart expired]) }
  scope :paid, -> { where.not(paid_at: nil) }
  scope :created_after, ->(days) { where(created_at: days.days.ago.beginning_of_day..Time.now) }
  scope :not_cart, -> { where.not(status: :cart) }
  scope :currency_balance, -> { where(payment_type: %i[btc])}
  scope :created_at,
    ->(begin_datetime, end_datetime) { where(created_at: begin_datetime..end_datetime) }

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
    payment_transaction
  end

  def adhesion_product
    @adhesion_product ||= products.detect(&:adhesion?)
  end

  def activation_product
    @activation_product ||= products.detect(&:activation?)
  end

  def token
    Digest::MD5.hexdigest("#{id * 1337}:#{hashid}")
  end

  def products
    @products ||= order_items.includes(product: [:trail]).map(&:product)
  end

  def detached_products_score
    items = order_items.includes(:product).select { |item| item.product.detached? }
    items.sum { |item| item.quantity.to_f * item.product.binary_score.to_f }
  end

  def activation_products_score
    items = order_items.includes(:product).select { |item| item.product.activation? }
    items.sum { |item| item.quantity * item.product.binary_score }
  end

  def item_price_cents_sum
    order_items.sum { |item| item.quantity * item.product.price_cents }
  end

  def paid!
    update_attributes(status: :completed, paid_at: Time.now)
  end

  def total_value
    total_cents / 100.0
  end
end
