class BackofficeController < ApplicationController

  include Pundit

  layout :define_layout

  before_action :authenticate_user!

  helper_method :current_order
  helper_method :current_courses_cart
  helper_method :clean_shopping_cart

  protected def current_order
   if session[:order_id].present? && current_user.orders.exists?(session[:order_id])
     @current_order ||= Order.find(session[:order_id])
   else
     @current_order ||= Order.new(user: current_user)
   end
  end

  def current_courses_cart
    @current_courses_cart ||= OrderItem.includes(:order)
                                       .where(product: Product.course, order: current_user.orders.cart)
                                       .order(created_at: :desc)
                                       .last
                                       .try(:order) || current_user.orders.includes(:order_items).cart.where(order_items: { id: nil }).last
    @current_courses_cart ||= Order.new(user: current_user, status: :cart)
  end

  def current_ads_cart
    @current_ads_cart ||= OrderItem.includes(:order)
                                   .where(product: Product.publicity, order: current_user.orders.cart)
                                   .order(created_at: :desc)
                                   .last
                                   .try(:order) || current_user.orders.includes(:order_items).cart.where(order_items: { id: nil }).last
    @current_ads_cart ||= Order.new(user: current_user, status: :cart)
  end

  def current_raffles_cart
    @current_raffles_cart ||= OrderItem.includes(:order).where(product: Product.raffle,order: current_user.orders.cart).order(created_at: :desc).last.try(:order) || current_user.orders.includes(:order_items).cart.where(order_items: { id: nil }).last
    @current_raffles_cart ||= Order.new(user: current_user, status: :cart)
  end

  protected def clean_shopping_cart
    session.delete(:order_id)
  end

  private def define_layout
    'admin'
  end

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

  def user_not_authorized
    flash[:alert] = 'Not authorized action.'
    redirect_to(request.referrer || root_path)
  end

  def clean_ads_cart
    @current_ads_cart = Order.new(user: current_user, status: :cart)
  end

  def clean_courses_cart
    @current_courses_cart = Order.new(user: current_user, status: :cart)
  end

  def clean_raffles_cart
    @current_raffles_cart = Order.new(user: current_user, status: :cart)
  end
end
