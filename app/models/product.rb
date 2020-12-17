class Product < ApplicationRecord
  include Hashid::Rails

  enum kind: [:detached, :adhesion, :activation, :voucher, :subscription, :deposit]
  enum paid_by: [:paid_by_user, :paid_by_company]

  has_attachment :main_photo
  has_attachments :photos

  belongs_to :category
  belongs_to :trail, optional: true
  has_many :product_reason_scores
  has_many :product_scores, through: :product_reason_scores
  has_many :career_trails
  has_many :shippings

  serialize :maturity_days, Array

  accepts_nested_attributes_for :shippings, reject_if: :all_blank, allow_destroy: true

  scope :regular, -> { where.not(kind: :activation) }
  scope :active, -> { where(active: true) }
  scope :sim_card, -> { where(category: Category.sim_card) }
  scope :cellphone_reloads, -> { where(category: Category.cellphone_reload).order(:price_cents) }

  validates :trail, presence: true, if: :adhesion?, on: :update
  validates :grace_period, presence: true, if: :adhesion?
  validates :grace_period, numericality: { only_integer: true,
                                           greater_than_or_equal_to: 0 }
  validates :code, presence: true, if: :activation?
  validates :sku, uniqueness: true, allow_blank: true
  validates :name, presence: true
  validates :kind, presence: true
  validates :binary_score, presence: true,
                           numericality: { only_integer: true,
                                           greater_than_or_equal_to: 0,
                                           allow_blank: true }
  validates :quantity, presence: true,
                       numericality: { only_integer: true,
                                       greater_than_or_equal_to: 0 }
  validates :low_stock_alert, numericality: { only_integer: true,
                                             greater_than_or_equal_to: 0,
                                             allow_blank: true }
  validates :price, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :length, numericality: { greater_than_or_equal_to: 0,
                                     allow_blank: true }
  validates :width, numericality: { greater_than_or_equal_to: 0,
                                     allow_blank: true }
  validates :height, numericality: { greater_than_or_equal_to: 0,
                                     allow_blank: true }
  validates :weight, numericality: { greater_than_or_equal_to: 0,
                                     allow_blank: true }

  def main_photo_id
    return ActionController::Base.helpers.asset_path('fallback/default_product.png') if main_photo.blank?
    main_photo.public_id
  end

  def regular?
    !adhesion?
  end

  def binary_bonus_percent
    binary_bonus.to_f / 100.0
  end

  def product_value
    price_cents.to_f / 100.0
  end

  def price
    price_cents.to_f / 100.0
  end

  def advance?
    code == Product.advance_product_code
  end

  def self.advance_product_code
    20
  end
end
