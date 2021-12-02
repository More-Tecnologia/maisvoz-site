class Banner < ApplicationRecord
  has_attachment :image

  belongs_to :banner_store

  validates :link, presence: true

  scope :active, -> { where(active: true) }
  scope :premium, -> { where(premium: true) }
  scope :default, -> { where(premium: false) }

  def path
    image.try(:fullpath)
  end
end
