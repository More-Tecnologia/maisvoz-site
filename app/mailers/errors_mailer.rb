class ErrorsMailer < ApplicationMailer

  def notify_admin(subject, errors)
    @errors = errors
    mail to: ENV['ERRORS_EMAIL'], subject: subject
  end

end
