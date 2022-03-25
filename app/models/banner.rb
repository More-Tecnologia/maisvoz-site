# frozen_string_literal: true

class Banner < ApplicationRecord
  has_attachment :image

  enum status: { pendent: 0, aproved: 1, canceled: 2, expired: 3, blocked: 4,
                 holding: 5, finish: 6 }

  belongs_to :banner_store
  belongs_to :user, optional: true

  validates :country_of_operation, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }
  validates :link, presence: true
  validates :title, presence: true, length: { maximum: 255 }

  scope :active, -> { where(active: true) }
  scope :premium, -> { where(premium: true) }
  scope :default, -> { where(premium: false) }

  def editable?
    pendent? || aproved? || blocked? || holding?
  end

  def path
    image.try(:fullpath)
  end
end
