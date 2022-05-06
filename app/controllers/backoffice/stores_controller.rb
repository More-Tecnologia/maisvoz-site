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
      @banner = Product.course
                       .active
                       .page(params[:page])
                       .limit(4)
    end

    def ads
      @packages = Product.publicity
                         .active
                         .order(:price_cents)
      @banner = Product.publicity
                       .active
                       .limit(4)
    end

    def raffles
      @packages = Product.raffle
                         .active
                         .includes(:raffle)
                         .order(:price_cents)
      @banner = Product.raffle
                       .active
                       .includes(:raffle)
                       .limit(4)
    end
  end
end
