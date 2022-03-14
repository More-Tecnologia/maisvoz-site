# frozen_string_literal: true

module Backoffice
  class CoursesController < BackofficeController
    def index
      if params[:status].present?
        @courses = current_user.courses
                               .__send__(params[:status])
                               .page(params[:page])
                               .per(10)
      else
        @courses = current_user.courses
                               .page(params[:page])
                               .per(10)
      end
    end
  end
end
