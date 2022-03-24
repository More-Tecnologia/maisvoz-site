# frozen_string_literal: true

module Courses
  class EnrollStudentService < ApplicationService
    def initialize(params)
      @courses = params[:courses]
      @student = params[:student]
    end

    private

    def call
      ActiveRecord::Base.transaction do
        enroll_courses
      end
    end

    def enroll_courses
      @courses.each do |course|
        @student.enroll_course(course)
      end
    end
  end
end
