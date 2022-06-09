# frozen_string_literal: true

module Raffles
  class ReserveTicketsService < ApplicationService
    def initialize(params)
      @product = params[:product]
      @ticket_numbers = (params[:numbers].presence || ',').split(',').map(&:to_i)
      @order = params[:order]
      @country = params[:country]
      @order_items = OrderItem.where(order: @order, product: @product)
      @order_items_size = @order_items.count
    end

    private

    def call
      ActiveRecord::Base.transaction do
        ticket_numbers_sanitizer
        return unless @ticket_numbers.any?

        @order.save!
        @ticket_numbers.each { |ticket_number| reserve_ticket(ticket_number) }
      end
    end

    def reserve_ticket(ticket_number)
      TicketOwnershipAssignorService.call(country: @country,
                                          order: @order,
                                          product: @product,
                                          ticket_number: ticket_number)
    end

    def ticket_numbers_sanitizer
      if @order_items_size >= ENV['MAX_TICKET_PER_ORDER'].to_i
        @ticket_numbers = []
      elsif (@order_items_size + @ticket_numbers.count) > ENV['MAX_TICKET_PER_ORDER'].to_i
        @ticket_numbers = @ticket_numbers[0...(ENV['MAX_TICKET_PER_ORDER'].to_i - @order_items_size)]
      end
    end
  end
end
