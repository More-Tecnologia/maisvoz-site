# frozen_string_literal: true

class Course < ApplicationRecord
  has_attachment :thumb
  enum days_to_cashback: { seven: 7, fifteen: 15, thirty: 30 }

  belongs_to :product
  belongs_to :owner, class_name: 'User'
  belongs_to :approver_user, class_name: 'User'

  has_many :item_categorizations, as: :itemable
  has_many :categorizations, through: :item_categorizations, source_type: "Itemable"
  has_many :course_lessons
  has_many :user_courses
  has_many :students, as: :users, through: :user_courses

  validates :content, presence: true
  validates :description, presence: true
  validates :language, presence: true
  validates :short_description, presence: true
  validates :title, presence: true

  delegate :username, to: :owner, prefix: :owner
  delegate :username, to: :approver_user, prefix: :approver

  def path
    thumb.try(:fullpath)
  end

  def add(category)
    category.itemables << self
  end

  def remove(category)
    category.itemables.delete(self)
  end
end
