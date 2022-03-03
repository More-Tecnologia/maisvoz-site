# frozen_string_literal: true

module Backoffice
  class TaughtCoursesController < BackofficeController
    before_action :ensure_course, only: %i[show edit update destroy]

    def index
      @courses = current_user.authorial_courses
                             .page(params[:page])
                             .per(10)
    end

    def show; end

    def new
      @course = Course.new
    end

    def create
      @course = Course.new(valid_course_params)
      flash[:error] = @course.errors.full_messages
      redirect_to backoffice_taught_courses_path
    end

    def edit; end

    def update
    end

    def destroy
      @course.toggle!(:active)

      redirect_to backoffice_taught_courses_path
    end

    private

    def build_course
      Courses::CreateService.call(course_params: valid_course_params, categories_ids: params[:categories_ids], product_params: valid_product_params)
    end

    def ensure_course
      @course = Course.find(params[:id])
    end

    def update_course
      Courses::UpdateService.call()
    end

    def valid_course_params
      params.require(:course)
            .permit(:title, :short_description, :language, :country_of_operation, :days_to_cashback,
                    :description, :content)
    end

    def valid_product_params

    end
  end
end
