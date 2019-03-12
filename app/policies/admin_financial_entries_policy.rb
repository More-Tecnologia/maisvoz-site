class AdminFinancialEntriesPolicy < ApplicationPolicy

  def index?
    user.admin? || user.financeiro?
  end

end
