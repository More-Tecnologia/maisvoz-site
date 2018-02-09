class Backoffice::DashboardController < BackofficeController

  def index
    render(
      :index,
      locals: {
        last_orders: last_orders,
        last_qualifications: last_qualifications
      }
    )
  end

  private

  def last_orders
    return unless current_user.admin?
    Order.order(created_at: :desc).last(10)
  end

  def last_qualifications
    @last_qualifications ||= CareerHistory.order(created_at: :desc).includes(:user).first(10)
  end

end
