class WithdrawalsMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.withdrawals_mailer.approved.subject
  #
  def approved
    category('withdrawal_approved')

    @withdrawal = params[:withdrawal]
    @user = @withdrawal.user

    mail to: @user.email, subject: 'FutureMotors - Pedido de Saque Aprovado'
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

    mail to: @user.email, subject: 'FutureMotors - Pedido de Saque Rejeitado'
  end
end
