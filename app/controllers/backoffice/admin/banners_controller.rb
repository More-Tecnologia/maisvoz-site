# frozen_string_literal: true

module Backoffice
  module Admin
    class BannersController < AdminController

      before_action :ensured_career, only: %i[edit update destroy]

      def index
        @banners = Banner.all
                         .page(params[:page])
                         .per(10)
      end

      def new
        @banner = Banner.new
      end

      def create
        @banner = Banner.new(ensured_params)
        if @banner.save
          flash[:success] = I18n.t(:success_create_banner)
          redirect_to backoffice_admin_banners_path
        else
          flash[:error] = I18n.t('defaults.saving_error')
          render :new
        end
      end

      def edit; end

      def update
        if @banner.update(ensured_params)
          flash[:success] = I18n.t(:success_update_banner)
          redirect_to backoffice_admin_banners_path
        else
          flash[:error] = I18n.t('defaults.saving_error')
          render :edit
        end
      end

      def destroy
        if @banner.update(active: false)
          flash[:success] = I18n.t(:success_inactivate_banner)
        else
          flash[:error] = I18n.t('defaults.destroying_error')
        end
        redirect_to backoffice_admin_banners_path
      end

      private

      def ensured_career
        @career = Banner.find(params[:id])
      end

      def ensured_params
        params.require(:banner).permit(:link, :image_path, :active)
      end
    end
  end
end
