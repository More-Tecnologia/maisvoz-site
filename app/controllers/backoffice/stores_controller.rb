module Backoffice
  class StoresController < EntrepreneurController
    def games; end

    def courses
      @courses = Course.active
                       .page(params[:page])
                       .per(4)
    end

    def ads; end
  end
end
