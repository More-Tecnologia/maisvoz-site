# frozen_string_literal: true

module Courses
  class CreateService < ApplicationService
    def initialize(params)
      @course_params = params[:course_params]
      @product_params = params[:product_params]
      @categories_ids = params[:categories_ids]
    end

    private

    def call
      ActiveRecord::Base.transaction do
        create_product
        create_course
        add_categories
        @course
      end
    end

    def create_product
      @product = ProductCreateService.call(@product_params)
    end

    def create_course
      @course = @product.create_course(@course_params)
    end

    def categories
      Categorization.where(id: @categories_ids)
    end

    def add_categories
      categories.each do |category|
        @course.add(category)
      end
    end
  end
end
