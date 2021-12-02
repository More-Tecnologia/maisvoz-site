class Banner < ApplicationRecord
  has_attachment :image

  belongs_to :banner_store

  validates :link, presence: true

  scope :active, -> { where(active: true) }

  def path
    image.try(:fullpath)
  end
end
