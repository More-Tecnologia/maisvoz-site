# frozen_string_literal: true

module Raffles
  class CreateService < ApplicationService
    def initialize(params)
      @raffle_params = params[:raffle_params]
      @product_params = params[:product_params]
      @thumb = @raffle_params.delete(:thumb)
      @images = @raffle_params.delete(:images)
    end

    private

    def add_images
      @raffle.update(thumb: @thumb, images: @images)
    end

    def call
      ActiveRecord::Base.transaction do
        create_product
        create_raffle!
        add_images
        create_raffle_tickets
      end
    end

    def create_product
      @product = ProductCreateService.call(@product_params)
    end

    def create_raffle!
      @raffle = @product.create_raffle!(@raffle_params)
    end

    def create_raffle_tickets
      RaffleTicketCreateWorker.perform_async(@raffle.id)
    end
  end
end
