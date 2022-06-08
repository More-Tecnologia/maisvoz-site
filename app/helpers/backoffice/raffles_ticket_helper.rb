# frozen_string_literal: true

module Backoffice
  module RafflesTicketHelper
    COLOR_BY_STATUS = {
      available: "number-raffle",
      reserved: "ticket-reserved",
      acquired: "ticket-bought"
    }
    
    def acquired_raffle_tickets_count(raffle)
      raffle.raffle_tickets.acquired.size
    end

    def available_raffle_tickets_count(raffle)
      raffle.raffle_tickets.available.size
    end
    
    def raffle_ticket_number_format(ticket)
      format("%0#{ticket.raffle.max_ticket_number.to_s.size}d", ticket.number % (ticket.raffle.max_ticket_number * 10))
    end

    def raffle_ticket_status(ticket)
      COLOR_BY_STATUS[ticket.status.to_sym]
    end

    def reserved_raffle_tickets_count(raffle)
      raffle.raffle_tickets.reserved.size
    end     
  end
end
