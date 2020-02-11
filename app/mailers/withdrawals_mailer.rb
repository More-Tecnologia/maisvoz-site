class WithdrawalsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.withdrawals_mailer.approved.subject
  #
  def approved
    category('withdrawal_approved')

    @withdrawal = params[:withdrawal]
    @locale = params[:locale]
    @user = @withdrawal.user

    mail to: @user.email, subject: "#{ENV['COMPANY_NAME']} - Pedido de Saque Aprovado"
  end

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.withdrawals_mailer.rejected.subject
  #
  def rejected
    category('withdrawal_rejected')

    @withdrawal = params[:withdrawal]
    @user = @withdrawal.user
    @locale = params[:locale]

    mail to: @user.email, subject: "#{ENV['COMPANY_NAME']} - Pedido de Saque Rejeitado"
  end

  def waiting
    @withdrawal = params[:withdrawal]
    @user = @withdrawal.user
    @locale = params[:locale]

    mail to: @user.email, subject: "#{ENV['COMPANY_NAME']} - Pedido de Saque Efetuado"
  end

  def canceled
    @withdrawal = params[:withdrawal]
    @user = @withdrawal.user
    @locale = params[:locale]

    mail to: @user.email, subject: "#{ENV['COMPANY_NAME']} - Pedido de Saque Cancelado"
  end
end
