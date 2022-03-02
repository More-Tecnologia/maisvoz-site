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

    end
  end
end
