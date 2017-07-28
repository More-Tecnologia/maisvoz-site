# == Schema Information
#
# Table name: products
#
#  id                     :integer          not null, primary key
#  name                   :string
#  description            :text
#  short_description      :string
#  sku                    :string(10)
#  quantity               :integer
#  low_stock_alert        :integer
#  weight                 :decimal(10, 2)
#  length                 :integer
#  width                  :integer
#  height                 :integer
#  price_cents            :integer
#  binary_score           :integer
#  advance_score          :integer
#  active                 :boolean
#  virtual                :boolean
#  paid_by                :integer
#  category_id            :integer
#  career_id              :integer
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
#  upgrade_from_career_id :integer
#  upgrade_to_career_id   :integer
#
# Indexes
#
#  index_products_on_career_id               (career_id)
#  index_products_on_category_id             (category_id)
#  index_products_on_upgrade_from_career_id  (upgrade_from_career_id)
#  index_products_on_upgrade_to_career_id    (upgrade_to_career_id)
#

class Product < ApplicationRecord

  enum kind: [:product, :monthly_payment, :adhesion, :promotion, :renovation, :upgrade]
  enum paid_by: [:paid_by_user, :paid_by_company]

  has_many :cloudinary_images, as: :imageable
  belongs_to :category
  belongs_to :career, optional: true
  belongs_to :upgrade_from_career, class_name: 'Career', optional: true
  belongs_to :upgrade_to_career, class_name: 'Career', optional: true

  monetize :price_cents

  scope :active, -> { where(active: true) }

  def thumbnail
    return CloudinaryImage.new.public_id if cloudinary_images.blank?
    cloudinary_images.first.public_id.thumbnail
  end

  def image
    return CloudinaryImage.new.public_id if cloudinary_images.blank?
    cloudinary_images.first.public_id
  end

end
