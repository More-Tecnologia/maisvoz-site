class BackofficeController < ApplicationController

  include Pundit

  layout :define_layout

  before_action :authenticate_user!

  helper_method :current_order

  protected def current_order
   if session[:order_id].present? && current_user.orders.exists?(session[:order_id])
     @current_order ||= Order.find(session[:order_id])
   else
     @current_order ||= Order.new(user: current_user)
   end
  end

  private def define_layout
    current_user.consumidor? ? 'consumer' : 'admin'
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = 'Você não tem autorização para realizar esta ação.'
    redirect_to(request.referrer || root_path)
  end

end
