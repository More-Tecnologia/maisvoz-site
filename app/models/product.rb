# == Schema Information
#
# Table name: products
#
#  id                     :bigint(8)        not null, primary key
#  name                   :string
#  description            :text
#  short_description      :string
#  sku                    :string(10)
#  quantity               :string
#  low_stock_alert        :integer
#  weight                 :decimal(10, 2)
#  length                 :decimal(10, 2)
#  width                  :decimal(10, 2)
#  height                 :decimal(10, 2)
#  price_cents            :bigint(8)
#  binary_score           :integer
#  advance_score          :integer
#  active                 :boolean
#  virtual                :boolean
#  paid_by                :integer
#  category_id            :bigint(8)
#  career_id              :bigint(8)
#  bonus_1                :integer
#  bonus_2                :integer
#  bonus_3                :integer
#  bonus_4                :integer
#  bonus_5                :integer
#  bonus_6                :integer
#  bonus_7                :integer
#  bonus_8                :integer
#  bonus_9                :integer
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  kind                   :integer
#  upgrade_from_career_id :bigint(8)
#  upgrade_to_career_id   :bigint(8)
#  binary_bonus           :decimal(, )
#  club_motors            :boolean          default(FALSE), not null
#  tracker                :boolean          default(FALSE), not null
#
# Indexes
#
#  index_products_on_career_id               (career_id)
#  index_products_on_category_id             (category_id)
#  index_products_on_upgrade_from_career_id  (upgrade_from_career_id)
#  index_products_on_upgrade_to_career_id    (upgrade_to_career_id)
#

class Product < ApplicationRecord

  include Hashid::Rails

  enum kind: [:detached, :adhesion, :activation, :voucher, :subscription]
  enum paid_by: [:paid_by_user, :paid_by_company]

  has_attachment :main_photo
  has_attachments :photos

  belongs_to :category, optional: true
  belongs_to :trail, optional: true
  has_many :product_reason_scores
  has_many :career_trails

  monetize :price_cents

  serialize :maturity_days, Array

  scope :regular, -> { where.not(kind: :activation) }
  scope :active, -> { where(active: true) }
  scope :sim_card, -> { where(category: Category.sim_card) }
  scope :cellphone_reloads, -> { where(category: Category.cellphone_reload).order(:price_cents) }

  validates :trail, presence: true, if: :adhesion?, on: :update
  validates :grace_period, presence: true, if: :adhesion?
  validates :grace_period, numericality: { only_integer: true,
                                           greater_than_or_equal_to: 0 }

  def main_photo_id
    return ActionController::Base.helpers.asset_path('fallback/default_product.png') if main_photo.blank?
    main_photo.public_id
  end

  def regular?
    !adhesion?
  end

  def system_taxable?
    kind.to_s.in?(Product.taxable_kinds)
  end

  def self.taxable_kinds
    kinds.keys
  end

  def binary_bonus_percent
    binary_bonus.to_f / 100.0
  end

  def product_value
    price_cents.to_f / 100.0
  end

end
