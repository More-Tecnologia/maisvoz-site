class OrderOfServicePolicy < ApplicationPolicy

  def index?
    admin_or_automotive_center?
  end

  def new?
    admin_or_automotive_center?
  end

  def create?
    admin_or_automotive_center?
  end

  def admin_or_automotive_center?
    user.admin? || user.automotive_center?
  end

  def resolve
    scope.all
  end

end
