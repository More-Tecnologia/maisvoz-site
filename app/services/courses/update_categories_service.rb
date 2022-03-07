# frozen_string_literal: true

module Courses
  class UpdateCategoriesService < ApplicationService
    def initialize(params)
      @course = params[:course]
      @categories_ids = params[:categories_ids]
    end

    private

    def call
      ActiveRecord::Base.transaction do
        add_categories
        remove_categories
      end
    end

    def categories
      Categorization.where(id: @categories_ids)
    end

    def add_categories
      AddCategoriesService.call(course: @course, categories_ids: new_categories_ids)
    end

    def remove_categories
      RemoveCategoriesService.call(course: @course, categories_ids: removed_categories_ids)
    end

    def new_categories_ids
      @categories_ids - course_categories_ids
    end

    def categories_ids
      @course.categories.map(&:id)
    end

    def removed_categories_ids
      course_categories_ids - @categories_ids
    end
  end
end
