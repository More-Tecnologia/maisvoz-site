# frozen_string_literal: true

module Raffles
  class ProductCreateService < ApplicationService
    def initialize(params)
      price_cents = params[:price_cents].gsub(/\.|,/, '').to_i
      @params = params.merge(price_cents: price_cents)
    end

    private

    def call
      create_product!
    end

    def create_product!
      Product.create!(@params.merge(product_attributes))
    end

    def product_attributes
      {
        binary_score: 0,
        virtual: true,
        kind: :raffle,
        category: raffle_category,
        system_taxable: true,
        generate_pool_points: false,
        quantity: 1,
        details: '#fff',
        task_per_day: 0
      }
    end

    def raffle_category
      Category.raffle
    end
  end
end
