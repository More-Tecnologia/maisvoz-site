# frozen_string_literal: true

module Raffles
  class ProductUpdateService < ApplicationService
    def initialize(params)
      @product = params[:product]
      price_cents = params[:attributes][:price_cents].gsub(/\.|,/, '').to_i
      @attributes = params[:attributes].merge(price_cents: price_cents)
    end

    private

    def call
      update_product!
    end

    def update_product!
      @product.update!(@attributes)
    end
  end
end
