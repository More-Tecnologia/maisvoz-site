# frozen_string_literal: true

module Backoffice
  module RafflesTicketHelper
    COLOR_BY_STATUS = {
      available: "number-raffle",
      reserved: "ticket-reserved",
      acquired: "ticket-bought"
    }

    def raffle_ticket_status(raffle, number)
      ticket = raffle.raffle_tickets.find_by(number: number)
      COLOR_BY_STATUS[ticket.status.to_sym]
    end
  end
end
