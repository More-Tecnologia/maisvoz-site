class CalculateUserActivityBonusRange

  def initialize(user)
    @user = user
  end

  def call
    if pv_activity_sum >= 700 && pv_activity_sum < 2800
      0.02
    elsif pv_activity_sum >= 2800 && pv_activity_sum < 4200
      0.04
    elsif pv_activity_sum >= 4200
      0.06
    elsif pv_semester_activity_sum >= 700
      0.02
    else
      0
    end
  end

  private

  attr_reader :user

  def pv_activity_sum
    @pv_activity_sum ||= (my_orders_pva + my_clients_pva) || 0
  end

  def my_orders_pva
    user.orders.where(
      'created_at > ?', 30.days.ago.beginning_of_day
    ).where(status: :completed).sum(:pv_total)
  end

  def my_clients_pva
    Order.where(user: user.sponsored.consumidor).where(
      'created_at > ?', 30.days.ago.beginning_of_day
    ).where(status: :completed).sum(:pv_total)
  end

  def pv_semester_activity_sum
    @pv_semester_activity_sum ||= user.orders.where(
      'created_at > ?', 180.days.ago.beginning_of_day
    ).where(status: :completed).sum(:pv_total)
  end

end
