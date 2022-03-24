# frozen_string_literal: true

class UserCourse < ApplicationRecord
  belongs_to :student, class_name: 'User', foreign_key: "user_id"
  belongs_to :course

  has_many :user_courses_lessons
end
