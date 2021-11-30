class TicketsMailer < ApplicationMailer
  def notify_admin
    @ticket = params[:ticket]

    mail to: ENV['tickets_notify_email'], subject: "#{SystemConfiguration.company_name} - " + t('tickets_notify_email') + " #{@ticket.hashid}"
  end
end
