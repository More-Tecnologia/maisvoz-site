class DigitalWalletsMailer < ApplicationMailer
  def confirmation
    @digital_wallet = params[:digital_wallet]
    @user = @digital_wallet.user
    @locale = params[:locale]

    mail to: @user.email, subject: "#{SystemConfiguration.company_name} - " + t('digital_wallet_change_solicitation')
  end

  def refused
    @digital_wallet = params[:digital_wallet]
    @wallet_address = @digital_wallet.user.wallet_address
    @user = @digital_wallet.user
    @locale = params[:locale]

    mail to: @user.email, subject: "#{SystemConfiguration.company_name} - " + t('digital_wallet_refuse_info')
  end

  def reactive
    @digital_wallet = params[:digital_wallet]
    @user = @digital_wallet.user
    @locale = params[:locale]

    mail to: @user.email, subject: "#{SystemConfiguration.company_name} - " + t('digital_wallet_reactive_info')
  end

  def activated
    @digital_wallet = params[:digital_wallet]
    @user = @digital_wallet.user
    @locale = params[:locale]

    mail to: @user.email, subject: "#{SystemConfiguration.company_name} - " + t('digital_wallet_changed_info')
  end
end
