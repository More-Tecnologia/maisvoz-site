class EmailsMailer < ApplicationMailer
  def confirmation
    @email = params[:email]
    @user = @email.user
    @locale = params[:locale]

    mail to: @user.email, subject: "#{SystemConfiguration.company_name} - " + t('email_change_solicitation')
  end

  def refused
    @email = params[:email]
    @current_email = @email.user.email
    @user = @email.user
    @locale = params[:locale]

    mail to: @current_email, subject: "#{SystemConfiguration.company_name} - " + t('email_refuse_info')
  end

  def reactive
    @email = params[:email]
    @current_email = @email.user.email
    @user = @email.user
    @locale = params[:locale]

    mail to: @current_email, subject: "#{SystemConfiguration.company_name} - " + t('email_reactive_info')
  end

  def activated
    @email = params[:email]
    @user = @email.user
    @user = @email.user
    @locale = params[:locale]

    mail to: @email, subject: "#{SystemConfiguration.company_name} - " + t('email_changed_info')
  end
end
