class ShoppingMailer < ApplicationMailer

  def order_made
    category('order_made')

    @order = params[:order]
    @user = @order.user

    mail to: @user.email, subject: "#{ENV['COMPANY_NAME']} - Pedido Realizado"
  end

  def order_paid
    category('order_paid')

    @order = params[:order]
    @user = @order.user

    mail to: @user.email, subject: "#{ENV['COMPANY_NAME']} - Pagamento Recebido"
  end

end
