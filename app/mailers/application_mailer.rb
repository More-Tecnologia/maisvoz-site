class ApplicationMailer < ActionMailer::Base

  default from: 'no-reply@morenwm.com'
  layout 'mailer'

  include Sendgrid

end
