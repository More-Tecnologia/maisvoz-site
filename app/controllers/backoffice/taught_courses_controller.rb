# frozen_string_literal: true

module Backoffice
  class TaughtCoursesController < BackofficeController
    def index
    end

    def show
    end

    def new
      @taught_course = Course.new
    end

    def create
      redirect_to backoffice_taught_courses_path
    end

    def edit
    end

    def update
    end

    def destroy
    end
  end
end
