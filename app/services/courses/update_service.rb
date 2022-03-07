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
        create_course
        update_categories
        @course
      end
    end

    def create_product
      ProductCreateService.call(@product, @product_params)
    end

    def create_course
      @course.update(@course_params)
    end


  end
end
