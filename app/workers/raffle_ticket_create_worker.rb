# frozen_string_literal: true

class RaffleTicketCreateWorker
  include Sidekiq::Worker

  def perform(raffle_id)
    raffle = Raffle.find(raffle_id)

    Raffles::RaffleTicketCreateService.call(raffle: raffle)
  end
end
