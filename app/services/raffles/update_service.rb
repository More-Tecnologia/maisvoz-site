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
      end
    end

    def update_product!
      ProductUpdateService.call(product: @product, attributes: @product_params)
    end

    def update_raffle!
      @raffle.update!(@raffle_params)
    end
  end
end
