class BackofficeController < ApplicationController

  include Pundit

  layout :define_layout

  before_action :authenticate_user!

  helper_method :current_order
  helper_method :current_deposit
  helper_method :clean_shopping_cart

  protected def current_order
   if session[:order_id].present? && current_user.orders.exists?(session[:order_id])
     @current_order ||= Order.find(session[:order_id])
   else
     @current_order ||= Order.new(user: current_user)
   end
  end

  def current_deposit
    @current_deposit ||= OrderItem.includes(:product, :order)
                                  .where(product: Product.deposit, order: current_user.orders.cart)
                                  .order(created_at: :desc)
                                  .last
                                  .try(:order) || Order.create(user: current_user, status: :cart)
    if @current_deposit.order_items.none?
      @current_deposit.order_items.create(product: Product.deposit.first, quantity: 50)
      Shopping::UpdateCartTotals.call(@current_deposit)
    end
    @current_deposit
  end

  protected def clean_shopping_cart
    session.delete(:order_id)
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
