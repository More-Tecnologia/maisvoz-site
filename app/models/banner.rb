# frozen_string_literal: true

class Banner < ApplicationRecord
  has_attachment :image

  enum status: { pending: 0, approved: 1, canceled: 2, expired: 3, blocked: 4,
                 holding: 5, finish: 6 }

  belongs_to :banner_store
  belongs_to :order, optional: true
  belongs_to :order_item, optional: true
  belongs_to :product, optional: true
  belongs_to :user, optional: true

  validates :country_of_operation, length: { maximum: 255 }
  validates :description, length: { maximum: 1000 }
  validates :link, presence: true
  validates :order, presence: true, on: :ads
  validates :order_item, presence: true, on: :ads
  validates :product, presence: true, on: :ads
  validates :user, presence: true, on: :ads
  validates :title, presence: true, length: { maximum: 255 }

  scope :active, -> { where(active: true) }
  scope :premium, -> { where(premium: true) }
  scope :default, -> { where(premium: false) }

  def approvable?
    pending? && !active? && paid?
  end

  def editable?
    pending? || aproved? || blocked? || holding?
  end

  def increment_view_count!
    increment!(:views)
  end

  def paid?
    order.completed?
  end

  def path
    image.try(:fullpath)
  end
end
