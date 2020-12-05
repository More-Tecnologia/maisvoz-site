class Banner < ApplicationRecord
  has_attachment :image

  validates :link, format: { with: URI::regexp },
                   presence: true
  validates :image_path, presence: true
end
