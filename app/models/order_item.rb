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
  include Hashid::Rails

  QUANTITIES = [10, 35, 55, 105, 255, 505, 1005, 2505, 5005]

  delegate :name, :adhesion?, to: :product
  delegate :earnings_per_campaign, to: :product
  delegate :task_per_day, to: :product

  belongs_to :order
  belongs_to :product
  has_one :ad, class_name: 'Banner', dependent: :destroy

  has_many :sim_cards

  monetize :unit_price_cents
  monetize :total_cents

  scope :activation, -> { where(product: Product.activation) }
  scope :sim_card, -> { where(product: Product.sim_card) }
  scope :paid, -> { where.not('orders.paid_at': nil) }
  scope :cellphone_reloads, ->() { where(product: Product.cellphone_reloads) }

  def total
    total_cents / 100.0
  end

  def unit_value
    unit_price_cents.to_f / 100.0
  end

  def total_quantity
    quantity.to_f * try(:product).try(:quantity).to_f
  end

  def processed?
    processed_at
  end

  def unprocessed?
    !processed?
  end

  def create_sim_cards(iccids)
    validates_sim_cards_count_less_than_or_equal_to_threshold!(iccids.count)
    attributes = order.user.support_point? ? { support_point_user: order.user } : { user: order.user }
    ActiveRecord::Base.transaction do
      iccids.map { |iccid| sim_cards.create!(attributes.merge(iccid: iccid)) }
      process! if sim_cards.count >= total_quantity
    end
  end

  def process!
    update!(processed_at: Time.current) unless processed?
  end

  def value
    total_cents.to_f / 100.0
  end

  def amount
    quantity * product.product_value
  end

  private

  def validates_sim_cards_count_less_than_or_equal_to_threshold!(iccids_count)
    count = iccids_count + sim_cards.count
    raise StandardError, I18n.t('defaults.sim_card_threshold_reached', count: total_quantity) if count > total_quantity
  end

end
