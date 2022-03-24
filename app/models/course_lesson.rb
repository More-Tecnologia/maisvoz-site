# frozen_string_literal: true

class CourseLesson < ApplicationRecord
  include Hashid::Rails

  has_attachment :thumb, accept: [:jpg, :png]
  has_attachments :attachments

  belongs_to :course
  has_many :user_course_lessons

  validates :title, presence: true
  validates :link, presence: true
  validates :description, presence: true

  def path
    thumb.try(:fullpath)
  end
end
