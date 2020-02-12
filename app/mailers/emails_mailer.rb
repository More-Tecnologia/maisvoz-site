class EmailsMailer < ApplicationMailer
  def confirmation
    @email = params[:email]
    @user = @email.user
    @locale = params[:locale]

    mail to: @user.email, subject: "#{ENV['COMPANY_NAME']} - " + t('email_change_solicitaion')
  end

  def changed
    @old_email = params[:email]
    @user = @old_email.user
    @locale = params[:locale]

    mail to: @old_email, subject: "#{ENV['COMPANY_NAME']} - " + t('email_changed_info')
  end
end
