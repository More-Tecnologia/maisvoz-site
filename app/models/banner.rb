class Banner < ApplicationRecord
  has_attachment :image

  validates :link, presence: true
  validates :image_path, presence: true

  scope :active, -> { where(active: true) }
end
