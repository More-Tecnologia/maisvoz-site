class AdminOrderPolicy < ApplicationPolicy

  def index?
    user.admin? || user.financeiro? || suporte?
  end

  def show?
    user.admin? || user.financeiro? || suporte?
  end

end
