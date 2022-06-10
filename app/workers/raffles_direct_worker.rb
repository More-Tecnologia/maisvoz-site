# frozen_string_literal: true

class RafflesDirectWorker
  include Sidekiq::Worker

  def perform(raffle_ticket_id)
    raffle_ticket = RaffleTicket.find(raffle_ticket_id)

    Bonification::RafflesDirectCreatorService.call(raffle_ticket: raffle_ticket)
  end
end
