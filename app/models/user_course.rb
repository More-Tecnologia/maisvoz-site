# frozen_string_literal: true

class UserCourse < ApplicationRecord
  belongs_to :user
  belongs_to :course
  has_many :user_courses_lessons
end
