class ProductDescription < ApplicationRecord
  MAIN_PHOTO_WIDTH = '860'
  MAIN_PHOTO_HEIGHT = '400'
  PHOTO_WIDTH = '400'
  PHOTO_HEIGHT = '400'

  has_one_attached :photo

  belongs_to :product

  validates :position, presence: true
end
