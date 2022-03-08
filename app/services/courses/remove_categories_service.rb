# frozen_string_literal: true

module Courses
  class RemoveCategoriesService < ApplicationService
    def initialize(params)
      @course = params[:course]
      @categories_ids = params[:categories_ids]
    end

    private

    def call
      ActiveRecord::Base.transaction do
        remove_categories
      end
    end

    def categories
      Categorization.where(id: @categories_ids)
    end

    def remove_categories
      categories.each do |category|
        @course.remove(category)
      end
    end
  end
end
