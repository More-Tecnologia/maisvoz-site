class AdminFinancialEntriesPolicy < ApplicationPolicy

  def index?
    user.admin? || user.financeiro? || suporte?
  end

end
