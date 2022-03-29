# frozen_string_literal: true

module Backoffice
  module Admin
    class CoursesController < AdminController
      before_action :ensure_course, only: %i[update destroy]

      def index
        @q = Course.includes(:owner, :approver_user)
                   .ransack(params)
        @courses = @q.result
                     .order(created_at: :desc)
                     .page(params[:page])
      end

      def update
        if  @course.update(approved: true, approver_user: current_user) && @course.product.update(active: true)
          flash[:success] = t(:approved_course)
        else
          flash[:error] = @course.errors.full_messages.join(', ') + ', ' + @course.product.errors.full_messages.join(', ')
        end

        redirect_to backoffice_admin_courses_path
      end

      def destroy
        if @course.update(active: false, approved: false) && @course.product.update(active: false)
         flash[:error] = t(:disallowed_course)
        else
          flash[:error] = @course.errors.full_messages.join(', ') + ', ' + @course.product.errors.full_messages.join(', ')
        end

        redirect_to backoffice_admin_courses_path
      end

      private

      def ensure_course
        @course = Course.find_by_hashid(params[:id])
      end
    end
  end
end
