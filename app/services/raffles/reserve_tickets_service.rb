# frozen_string_literal: true

module Raffles
  class ReserveTicketsService < ApplicationService
    def initialize(params)
      @product = params[:product]
      @ticket_numbers = params[:ticket_numbers]
      @order = params[:order]
      @country = params[:country]
    end

    private

    def call
      ActiveRecord::Base.transaction do
        @ticket_numbers.each do |ticket_number|
          reserve_ticket(ticket_number)
        end
      end
    end

    def reserve_ticket(ticket_number)
      TicketOwnershipAssignorService.call(country: @country,
                                          order: @order,
                                          product: @product,
                                          ticket_number: ticket_number)
    end
  end
end
