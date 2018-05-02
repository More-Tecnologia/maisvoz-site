class BradescoCheckOrderController < ActionController::Base

  def index
    if valid_request?
      head :ok
    else
      head :bad_request
    end
  end

  protected

  def valid_request?
    return false if params[:numero_pedido].blank? || params[:token].blank?
    order = Order.find(params[:numero_pedido])
    order.token == params[:token]
  rescue ActiveRecord::RecordNotFound
    return false
  end

end
