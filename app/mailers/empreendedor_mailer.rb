class EmpreendedorMailer < ApplicationMailer

  def welcome_email(user)
    category('empreendedor_welcome')
    mail to: user.email, subject: 'FutureMotors - Parabéns'
  end

end
