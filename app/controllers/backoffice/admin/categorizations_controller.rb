# frozen_string_literal: true

module Backoffice
  module Admin
    class CategorizationsController < AdminController
      before_action :ensure_categorization, only: %i[show edit update destroy]

      def index
        @q = Categorization.ransack(params)
        @categorizations = @q.result
                             .order(created_at: :desc)
                             .page(params[:page])
      end

      def show; end

      def new
        @categorization = Categorization.new
      end

      def create
        @categorization = Categorization.new(ensured_params)
        if @categorization.save!
          flash[:success] = I18n.t('defaults.success')
          redirect_to [:backoffice, :admin, @categorization]
        else
          flash[:error] = @categorization.errors.map(&:message)
          render 'new'
        end
      end

      def edit; end

      def update
        if @categorization.update!(ensured_params)
          flash[:success] = I18n.t('defaults.success')
          redirect_to [:backoffice, :admin, @categorization]
        else
          flash[:error] = @categorization.errors.map(&:message)
          render 'edit'
        end
      end

      def destroy
        @categorization.inactive
        redirect_to backoffice_admin_categorizations_path
      end

      private

      def ensure_categorization
        @categorization = Categorization.find_by_hashid(params[:id])
      end

      def ensured_params
        params.require(:categorization).permit(:tag, :title, :active)
      end
    end
  end
end
