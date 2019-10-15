class ShoppingMailer < ApplicationMailer


  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.shopping_mailer.order_made.subject
  #
  def order_made
    category('order_made')

    @order = params[:order]
    @user = @order.user

    mail to: @user.email, subject: 'More Network Marketing - Pedido Realizado'
  end

  def order_paid
    category('order_paid')

    @order = params[:order]
    @user = @order.user

    mail to: @user.email, subject: 'More Network Marketing - Pagamento Recebido'
  end

end
