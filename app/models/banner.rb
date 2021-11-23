class Banner < ApplicationRecord
  has_attachment :image

  validates :link, presence: true

  scope :active, -> { where(active: true) }

  def path
    image.try(:fullpath)
  end

  def filename
    "#{title}.#{image.format}"
  end
end
