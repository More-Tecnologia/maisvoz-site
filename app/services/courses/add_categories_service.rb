# frozen_string_literal: true

module Courses
  class AddCategoriesService < ApplicationService
    def initialize(params)
      @course = params[:course]
      @categories_ids = params[:categories_ids]
    end

    private

    def call
      ActiveRecord::Base.transaction do
        add_categories
      end
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
