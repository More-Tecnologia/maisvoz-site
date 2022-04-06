# frozen_string_literal: true

module Raffles
  class ReserveTicketsService < ApplicationService
    def initialize(params)
      @product = params[:product]
      @ticket_numbers = (params[:numbers].presence || ',').split(',').map(&:to_i)
      @random_ticket_numbers = params[:random_number_quantity].to_i
      @order = params[:order]
      @country = params[:country]
    end

    private

    def call
      ActiveRecord::Base.transaction do
        @order.save!
        if @ticket_numbers.any?
          @ticket_numbers.each do |ticket_number|
            reserve_ticket(ticket_number)
          end
        end
        unless @random_ticket_numbers.zero?
          @random_ticket_numbers.times do
            ticket_number = @product.raffle.raffle_tickets.available.sample.number
            reserve_ticket(ticket_number)
          end
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
