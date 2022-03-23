class Banner < ApplicationRecord
  has_attachment :image
  
  enum status: { pendent: 0, aproved: 1, canceled: 2, expired: 3, blocked: 4, 
                 holding: 5, finish: 6 }

  belongs_to :banner_store
  belongs_to :user

  validates :country_of_operation, length: { maximum: 255 }
  validates :title, presence: true, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }
  validates :link, presence: true

  scope :active, -> { where(active: true) }
  scope :premium, -> { where(premium: true) }
  scope :default, -> { where(premium: false) }

  def path
    image.try(:fullpath)
  end
end
