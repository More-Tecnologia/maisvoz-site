# frozen_string_literal: true

module Raffles
  class ProcessRaffleTicketService < ApplicationService
    def initialize(params)
      @raffle_ticket = params[:raffle_ticket]
    end

    private

    def all_tickets_acquired?
      @raffle_ticket.raffle.raffle_tickets.acquired.count == @raffle_ticket.raffle.max_ticket_number
    end

    def call
      process_raffle_ticket
      end_ticket_purchase_time if all_tickets_acquired?
    end

    def process_raffle_ticket
      @raffle_ticket.acquired!
    end

    def end_ticket_purchase_time
      @raffle_ticket.raffle.awaiting_draw_date!
    end
  end
end
