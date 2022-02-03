# frozen_string_literal: true

class CourseLesson < ApplicationRecord
  has_attachment :thumb
  has_attachments :attachments

  belongs_to :course
  has_many :user_course_lessons

  validates :title, presence: true
  validates :link, presence: true
  validates :description, presence: true
end
