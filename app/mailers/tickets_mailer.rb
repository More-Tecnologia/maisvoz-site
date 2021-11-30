class TicketsMailer < ApplicationMailer
  def notify_admin
    @ticket = params[:ticket]

    mail to: ENV['TICKET_NOTIFY_EMAIL'], subject: "#{SystemConfiguration.company_name} - " + t('tickets_notify_email') + " #{@ticket.hashid}"
  end
end
