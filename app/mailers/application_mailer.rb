class ApplicationMailer < ActionMailer::Base

  default from: 'no-reply@futuremotors.com.br'
  layout 'mailer'

  include Sendgrid

end
