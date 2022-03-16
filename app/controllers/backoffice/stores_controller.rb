module Backoffice
  class StoresController < EntrepreneurController
    def games; end

    def course
      @course = Course.find_by_hashid(params[:id])

      redirect_to backoffice_course_path(@course) if @course.in?(current_user.courses)
    end

    def courses
      @courses = Course.active
                       .page(params[:page])
                       .per(4)
    end

    def ads; end
  end
end
