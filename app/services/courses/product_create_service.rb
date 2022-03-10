# frozen_string_literal: true

module Courses
  class ProductCreateService < ApplicationService
    def initialize(params)
      @price = params[:price].to_f * 100
      @title = params[:title]
      @network_commission_percentage = params[:network_commission_percentage]
    end

    private

    def call
      build_product
    end

    def course_category
      Category.course
    end

    def build_product
      Product.create!(product_attributes)
    end

    def product_attributes
      { name: @title,
        price_cents: @price,
        binary_score: 0,
        active: false,
        virtual: true,
        kind: :course,
        category: course_category,
        system_taxable: true,
        generate_pool_points: false,
        quantity: 1,
        details: '#fff',
        task_per_day: 0,
        network_commission_percentage: @network_commission_percentage}
    end
  end
end
