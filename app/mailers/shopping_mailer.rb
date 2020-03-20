class ShoppingMailer < ApplicationMailer

  def order_made
    category('order_made')

    @order = params[:order]
    @user = @order.user

    mail to: @user.email, subject: "#{ENV['COMPANY_NAME']} - Deposit Solicitation"
  end

  def order_paid
    category('order_paid')

    @order = params[:order]
    @user = @order.user

    mail to: @user.email, subject: "#{ENV['COMPANY_NAME']} - Deposit done"
  end

end
