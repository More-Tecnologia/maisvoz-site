# frozen_string_literal: true

module Courses
  class UpdateService < ApplicationService
    def initialize(params)
      @course = params[:course]
      @product = @course.product
      @course_params = params[:course_params]
      @product_params = params[:product_params]
      @categories_ids = params[:categories_ids]
    end

    private

    def call
      ActiveRecord::Base.transaction do
        update_product
        update_course
        update_categories
      end
    end

    def update_product
      ProductUpdateService.call(@product_params.merge(product: @product))
    end

    def update_course
      @course.update!(@course_params)
    end

    def update_categories
      UpdateCategoriesService.call(course: @course, categories_ids: @categories_ids)
    end
  end
end
