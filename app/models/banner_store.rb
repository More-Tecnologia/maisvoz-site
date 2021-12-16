class BannerStore < ApplicationRecord
  include Hashid::Rails
  has_attachment :image

  has_many :banners

  validates :title, presence: true

  scope :active, -> { where(active: true) }

  def path
    image.try(:fullpath)
  end
end
