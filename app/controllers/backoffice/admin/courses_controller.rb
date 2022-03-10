# frozen_string_literal: true

module Backoffice
  module Admin
    class CoursesController < AdminController
      before_action :ensure_course, only: %i[update destroy]

      def index
        @q = Course.ransack(params)
        @courses = @q.result
                     .order(created_at: :desc)
                     .page(params[:page])
      end

      def update
        @course.update(approved: true, approver_user: current_user)
        flash[:success] = t(:approved_course)

        redirect_to backoffice_admin_courses_path
      end

      def destroy
        @course.update(approved: false)
        flash[:error] = t(:disallowed_course)

        redirect_to backoffice_admin_courses_path
      end

      private

      def ensure_course
        @course = Course.find_by_hashid(params[:id])
      end
    end
  end
end
