# frozen_string_literal: true

module Courses
  class ProductUpdateService < ApplicationService
    def initialize(params)
      @product = params[:product]
      @price = params[:price].to_f * 100
      @title = params[:title]
      @network_commission_percentage = params[:network_commission_percentage]
    end

    private

    def call
      ActiveRecord::Base.transaction do
        update_product
      end
    end

    def update_product
      Product.update(product_attributes)
    end

    def product_attributes
      { name: @title,
        price_cents: @price,
        network_commission_percentage: @network_commission_percentage}
    end
  end
end
