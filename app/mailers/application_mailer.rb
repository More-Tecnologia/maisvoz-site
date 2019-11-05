class ApplicationMailer < ActionMailer::Base

  default from: 'no-reply@maisvoz.com.br'
  layout 'mailer'

  include Sendgrid

end
