# frozen_string_literal: true

class UserCourseLesson < ApplicationRecord
  belongs_to :user_course
  belongs_to :course_lesson

  delegate :user, :course, to: :user_course
end
