module Backoffice
  class StoresController < EntrepreneurController
    skip_before_action :authenticate_user!

    def games; end

    def course
      @course = Course.find_by_hashid(params[:id])
      return unless current_user.present? && @course.in?(current_user.courses)

      redirect_to backoffice_course_path(@course)
    end

    def courses
      @courses = Course.active
                       .page(params[:page])
                       .per(4)
      #TODO: Create logic for get various categories
      @banner = Product.course
                       .active
                       .page(params[:page])
    end

    def ads
      @packages = Product.publicity
                         .active
                         .order(:price_cents)
      #TODO: Create a query to get the product one level uper than the current sined by the user 
      @banner = Product.publicity
                       .active
                       .limit(4)
    end

    def raffles
      @packages = Product.raffle
                         .active
                         .includes(:raffle)
                         .order(:price_cents)
      #TODO: Create a query to get the raffles with lass thickets available
      @banner = Product.raffle
                       .active
                       .includes(:raffle)
                       .limit(4)
    end
  end
end
