class ClientsMailer < ApplicationMailer
  def sender(params)
    @name = params[:name]
    @email = params[:email]
    @subject = params[:subject]
    @message = params[:message]
    mail to: @email, subject: @subject
  end
end
