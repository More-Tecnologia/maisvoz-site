# frozen_string_literal: true

module Raffles
  class ProcessRaffleTicketService < ApplicationService
    def initialize(params)
      @raffle_ticket = params[:raffle_ticket]
    end

    private

    def call
      process_raffle_ticket
    end

    def process_raffle_ticket
      @raffle_ticket.acquired!
    end
  end
end
