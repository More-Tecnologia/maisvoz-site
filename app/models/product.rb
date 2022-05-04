class Product < ApplicationRecord
  include Hashid::Rails

  MAXIMUM_NUMBER_OF_PHOTOS = 6
  MAXIMUM_NUMBER_OF_PRODUCT_DESCRIPTIONS = 4
  PHOTO_WIDTH = '500'
  PHOTO_HEIGHT = '300'

  enum kind: %i[detached adhesion activation voucher
                subscription deposit course publicity crypto
                raffle]
  enum paid_by: [:paid_by_user, :paid_by_company]

  has_one_attached :main_photo
  has_many_attached :photos

  belongs_to :category
  belongs_to :trail, optional: true
  has_one :course
  has_one :raffle
  has_many :product_reason_scores
  has_many :product_scores, through: :product_reason_scores
  has_many :career_trails
  has_many :shippings
  has_many :product_descriptions
  has_many :ads, class_name: 'Banner'
  has_many :order_items
  has_many :orders, through: :order_items

  serialize :maturity_days, Array

  accepts_nested_attributes_for :shippings, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :product_descriptions, allow_destroy: true, reject_if: proc{ |attributes| attributes['photo'].nil? && attributes['description'].blank? }

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
  # validates :main_photo, attached: true
  validates :network_commission_percentage, presence: true, numericality: { greater_than_or_equal_to: ENV['MIN_NETWORK_COMMISION'].to_i }, if: :course?

  validate :photos_quantity_limit
  validate :photos_types

  delegate :path, to: :course, prefix: true, allow_nil: true
  delegate :path, to: :raffle, prefix: true, allow_nil: true

  def main_photo_path
    return ActionController::Base.helpers.asset_path('fallback/default_product.png') if !main_photo.attached?
    Rails.application.routes.url_helpers.rails_blob_path(main_photo, only_path: true)
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

  def photos_quantity_limit
    errors.add(:photos, :maximum_number, maximum_number: MAXIMUM_NUMBER_OF_PHOTOS) if photos.length > MAXIMUM_NUMBER_OF_PHOTOS
  end

  def photos_types
    photos.each do |photo|
      if !photo.content_type.in?(%('image/jpeg image/png'))
        errors.add(:photos, I18n.t('activerecord.errors.models.product.attributes.photos.types'))
      end
    end
  end

  def free_product?
    self == self.class.first
  end
end
