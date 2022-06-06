class ShoppingMailer < ApplicationMailer

  def order_made
    category('order_made')

    @order = params[:order]
    @user = @order.user
    @products = @order.products.includes(:raffle).uniq
    mail to: @user.email, subject: "#{SystemConfiguration.company_name} - #{t(:product_solicitation)}"
  end

  def order_paid
    category('order_paid')

    @order = params[:order]
    @user = @order.user

    mail to: @user.email, subject: "#{SystemConfiguration.company_name} - #{t(:purchased_product)}"
  end

end
