# frozen_string_literal: true

module Backoffice
  class CourseLessonsController < BackofficeController
    before_action :ensure_course_lesson, only: %i[edit update destroy]

    def new
      @course = Course.find_by_hashid(params[:course_id])
      @course_lesson = CourseLesson.new
    end

    def create
      # this step is necessary because of attachinary gem bug -
      # https://github.com/assembler/attachinary/issues/130
      # Remove this gem in favor of active storage
      new_params = valid_params
      file = new_params.delete(:thumb)

      @course_lesson = CourseLesson.new(new_params)
      @course_lesson.save
      @course_lesson.course.update(approved: false, active: false)
      @course_lesson.update(thumb: file)
    end

    def edit
      @course = @course_lesson.course
    end

    def update
      @course_lesson.update(valid_params)
      @course_lesson.course.update(approved: false, active: false)
    end

    def destroy
      @course_lesson.toggle!(:active)
      @course_lesson.course.update(approved: false, active: false)
    end

    def video
      @course_lesson = CourseLesson.find_by_hashid(params[:id])
    end

    private

    def ensure_course_lesson
      @course_lesson = CourseLesson.find(params[:id])
    end

    def valid_params
      params.require(:course_lesson)
            .permit(:course_id, :preview, :title, :description, :link, :thumb)
    end
  end
end
