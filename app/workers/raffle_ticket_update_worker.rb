# frozen_string_literal: true

class RaffleTicketUpdateWorker
  include Sidekiq::Worker

  def perform(raffle_id)
    raffle = Raffle.find(raffle_id)

    Raffles::RaffleTicketUpdateService.call(raffle: raffle)
  end
end
