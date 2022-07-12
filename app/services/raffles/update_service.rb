# frozen_string_literal: true

module Raffles
  class UpdateService < ApplicationService
    def initialize(params)
      @raffle = params[:raffle]
      @product = @raffle.product
      @raffle_params = params[:raffle_params]
      @product_params = params[:product_params]
    end

    private

    def call
      ActiveRecord::Base.transaction do
        update_product!
        update_raffle!
        update_raffle_tickets if @raffle.max_ticket_number != @raffle.raffle_tickets.count
      end
    end

    def update_product!
      ProductUpdateService.call(product: @product, attributes: @product_params)
    end

    def update_raffle!
      @raffle.update!(@raffle_params)
    end

    def update_raffle_tickets
      RaffleTicketUpdateWorker.perform_async(@raffle.id)
    end
  end
end
