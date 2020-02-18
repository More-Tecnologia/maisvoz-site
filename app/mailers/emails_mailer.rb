class EmailsMailer < ApplicationMailer
  def confirmation
    @email = params[:email]
    @user = @email.user
    @locale = params[:locale]

    mail to: @user.email, subject: "#{ENV['COMPANY_NAME']} - " + t('email_change_solicitation')
  end

  def refused
    @email = params[:email]
    @current_email = @email.user.email
    @user = @email.user
    @locale = params[:locale]

    mail to: @current_email, subject: "#{ENV['COMPANY_NAME']} - " + t('email_refuse_info')
  end

  def reactive
    @email = params[:email]
    @current_email = @email.user.email
    @user = @email.user
    @locale = params[:locale]

    mail to: @current_email, subject: "#{ENV['COMPANY_NAME']} - " + t('email_reactive_info')
  end

  def activated
    @email = params[:email]
    @user = @email.user
    @user = @email.user
    @locale = params[:locale]

    mail to: @email, subject: "#{ENV['COMPANY_NAME']} - " + t('email_changed_info')
  end
end
