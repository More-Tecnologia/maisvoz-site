class AdminCareerHistoriesPolicy < ApplicationPolicy

  def index?
    user.admin? || suporte?
  end

end
