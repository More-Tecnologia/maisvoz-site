module Backoffice
  class CareerTrailUsersController < EntrepreneurController

    def index
      @career_trail_users = current_user.career_trail_users
                                        .includes(career_trail: [:career, :trail])
    end

  end
end
