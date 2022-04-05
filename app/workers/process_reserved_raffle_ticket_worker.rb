# frozen_string_literal: true

class ProcessReservedRaffleTicketWorker
  include Sidekiq::Worker

  def perform(raffle_ticket_id)
    raffle_ticket = RaffleTicket.find(raffle_ticket_id)

    Raffles::ProcessRaffleTicketService.call(raffle_ticket: raffle_ticket)
  end
end
