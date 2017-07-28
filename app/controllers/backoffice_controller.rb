class BackofficeController < ApplicationController

  protect_from_forgery with: :exception

  layout 'admin'

  before_action :authenticate_user!

  helper_method :current_order

  def current_order
   if !session[:order_id].nil? && Order.exists?(session[:order_id])
     @current_order ||= Order.find(session[:order_id])
   else
     @current_order ||= Order.new(user: current_user)
   end
  end

end
