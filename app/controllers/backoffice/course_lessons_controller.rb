# frozen_string_literal: true

module Backoffice
  class CourseLessonsController < BackofficeController
    before_action :ensure_course_lesson, only: %i[edit update destroy]

    def new
      @course = Course.find_by_hashid(params[:course_id])
      @course_lesson = CourseLesson.new
    end

    def create
      @course_lesson = CourseLesson.create(valid_params)
    end

    def edit
      @course = @course_lesson.course
    end

    def update
      @course_lesson.update(valid_params)
    end

    def destroy
      @course_lesson.toggle!(:active)
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
            .permit(:course_id, :preview, :title, :description, :link)
    end
  end
end
