class ApplicationMailer < ActionMailer::Base

  default from: 'no-reply@moretecnology.com.br'
  layout 'mailer'

  include Sendgrid

end
