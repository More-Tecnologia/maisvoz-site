class Backoffice::DashboardController < BackofficeController

  def index
    render(
      :index,
      locals: {
        last_orders: last_orders
      }
    )
  end

  private

  def last_orders
    return unless current_user.admin?
    Order.order(created_at: :desc).last(10)
  end

end
