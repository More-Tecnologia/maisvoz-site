class UserMailer < ApplicationMailer

  def welcome(user)
    @user = user
    mail to: @user.email
  end

  def upgrade_career(user, new_career)
    @user = user
    @new_career = new_career
    mail to: @user.email, subject: I18n.t('user_mailer.upgrade_career.subject')
  end

end
