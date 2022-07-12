# frozen_string_literal: true

module Raffles
  class RaffleTicketCreateService < ApplicationService
    def initialize(params)
      @raffle = params[:raffle]
    end

    private

    def call
      (0...@raffle.max_ticket_number).each do |number|
        create_raffle_ticket!(number)
      end
    end

    def create_raffle_ticket!(number)
      @raffle.raffle_tickets.create!(number: number)
    end
  end
end
