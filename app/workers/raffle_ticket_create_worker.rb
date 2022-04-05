# frozen_string_literal: true

class RaffleTicketCreateWorker
  include Sidekiq::Worker

  def perform(raffle_id)
    raffle = Raffle.find(raffle_id)

    RaffleTicketCreateService.call(raffle)
  end
end
