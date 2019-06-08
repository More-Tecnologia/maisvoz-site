class InspectionMailer < ApplicationMailer

  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.inspection_mailer.approved.subject
  #
  def approved
    @inspection = params[:inspection]
    @user = @inspection.user

    mail to: @user.email, subject: "A vistoria do veículo de placa #{@inspection.plate} foi ativada"
  end
end
