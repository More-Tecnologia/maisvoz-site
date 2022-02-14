# frozen_string_literal: true

module Backoffice
  module Admin
    class CoursesController < AdminController
      def index
        @q = Course.ransack(params)
        @courses = @q.result
                     .order(created_at: :desc)
                     .page(params[:page])
      end

      def update
      end

      def destroy
      end
    end
  end
end
