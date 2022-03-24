# frozen_string_literal: true

module Courses
  class CreateService < ApplicationService
    def initialize(params)
      @course_params = params[:course_params]
      @product_params = params[:product_params]
      @categories_ids = params[:categories_ids]
      @thumb = @course_params.delete(:thumb)
    end

    private

    def add_categories
      AddCategoriesService.call(course: @course, categories_ids: @categories_ids)
    end

    def add_thumb
      @course.update(thumb: @thumb)
    end

    def call
      ActiveRecord::Base.transaction do
        create_product
        create_course
        add_thumb
        add_categories
      end
    end

    def create_course
      @course = @product.create_course!(@course_params)
    end

    def create_product
      @product = ProductCreateService.call(@product_params)
    end
  end
end
