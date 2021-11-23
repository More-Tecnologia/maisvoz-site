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
        flash[:success] = I18n.t(:success_create_banner)
        redirect_to backoffice_admin_banners_path
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

      def ensure_creation
        # this step is necessary because of attachinary gem bug -
        # https://github.com/assembler/attachinary/issues/130
        # Remove this gem in favor of active storage
        new_params = ensured_params
        file = new_params.delete(:image)

        @banner = Banner.new(new_params)
        @banner.save
        return if @banner.persisted? && @banner.update(image: file)

        flash[:error] = @banner.errors.full_messages.join(', ')
        @banner.destroy
        render :new
      end

      def ensured_career
        @banner = Banner.find(params[:id])
      end

      def ensured_params
        params.require(:banner).permit(:link, :image_path, :active, :image)
      end
    end
  end
end
