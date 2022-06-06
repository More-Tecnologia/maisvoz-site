# frozen_string_literal: true

module Raffles
  class RaffleTicketUpdateService < ApplicationService
    def initialize(params)
      @raffle = params[:raffle]
      @raffle_ticket_count = @raffle.raffle_tickets.count
    end

    private

    def call
      if @raffle_ticket_count < @raffle.max_ticket_number
        create_additional_tickets
      else
        remove_additional_tickets
      end
    end

    def create_raffle_ticket!(number)
      @raffle.raffle_tickets.create!(number: number)
    end

    def create_additional_tickets
      (@raffle_ticket_count...@raffle.max_ticket_number).each do |number|
        create_raffle_ticket!(number)
      end
    end

    def remove_additional_tickets
      @raffle.raffle_tickets.last(@raffle_ticket_count - @raffle.max_ticket_number).each do |raffle_ticket|
        raffle_ticket.destroy
      end
    end
  end
end
