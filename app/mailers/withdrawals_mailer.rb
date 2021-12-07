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

    mail to: @user.email, subject: "#{SystemConfiguration.company_name} - " + t('withdrawal_solicitation') + ' ' + t('approved')
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

    mail to: @user.email, subject: "#{SystemConfiguration.company_name} - " + t('withdrawal_solicitation') + ' ' + t('rejected')
  end

  def waiting
    @withdrawal = params[:withdrawal]
    @user = @withdrawal.user
    @locale = params[:locale]

    mail to: @user.email, subject: "#{SystemConfiguration.company_name} - "  + t('withdrawal_solicitation') + ' ' + t('effected')
  end

  def canceled
    @withdrawal = params[:withdrawal]
    @user = @withdrawal.user
    @locale = params[:locale]

    mail to: @user.email, subject: "#{SystemConfiguration.company_name} - " + t('withdrawal_solicitation') + ' ' + t('canceled')
  end
end
