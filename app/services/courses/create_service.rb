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
      end
    end

    def create_product
      @product = ProductCreateService.call(@product_params)
    end

    def create_course
      @course = @product.create_course!(@course_params)
    end

    def add_categories
      AddCategoriesService.call(course: @course, categories_ids: @categories_ids)
    end
  end
end
