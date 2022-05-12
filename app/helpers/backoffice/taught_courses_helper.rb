module Backoffice
  module TaughtCoursesHelper
    def course_status_button(course)
      if course.active? && course.approved?
        'status-active'
      elsif course.active? && !course.approved?
        'status-waiting'
      elsif !course.active?
        'status-inactive'
      end
    end

    def course_status(course)
      if course.active? && course.approved?
        t(:active)
      elsif course.active? && !course.approved?
        t(:waiting)
      elsif !course.active?
        t(:inactive)
      end
    end
  end
end
