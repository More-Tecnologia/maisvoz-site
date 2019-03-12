class AdminBonusEntriesPolicy < ApplicationPolicy

  def index?
    user.admin? || user.financeiro?
  end

end
