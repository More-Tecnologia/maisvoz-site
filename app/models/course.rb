# frozen_string_literal: true

class Course < ApplicationRecord
  include Hashid::Rails

  has_attachment :thumb, accept: [:jpg, :png]
  enum days_to_cashback: { seven: 7, fifteen: 15, thirty: 30 }

  belongs_to :product
  belongs_to :owner, class_name: 'User'
  belongs_to :approver_user, class_name: 'User', optional: true

  has_many :item_categorizations, as: :itemable
  has_many :categorizations, through: :item_categorizations
  has_many :course_lessons
  has_many :user_courses
  has_many :students, through: :user_courses

  validates :content, presence: true
  validates :description, presence: true
  validates :language, presence: true
  validates :short_description, presence: true
  validates :title, presence: true

  delegate :username, :name, to: :owner, prefix: :owner
  delegate :username, to: :approver_user, prefix: :approver, allow_nil: true
  delegate :price, :network_commission_percentage, to: :product, allow_nil: true

  scope :active, -> { where(active: true, approved: true) }
  scope :inactive, -> { where(active: false) }
  scope :waiting, -> { where(active: true, approved: false) }

  def path
    thumb.try(:fullpath) || 'courses/course2.png'
  end

  def add(category)
    category.courses << self
  end

  def owner_name
    self[:owner_name].presence || I18n.t(:anonymous)
  end

  def remove(category)
    category.courses.delete(self)
  end
end
