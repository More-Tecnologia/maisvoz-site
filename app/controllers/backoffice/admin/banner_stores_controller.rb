# frozen_string_literal: true

module Backoffice
  module Admin
    class BannerStoresController < AdminController
      before_action :ensure_creation, only: :create
      before_action :ensured_banner_store, only: %i[edit update destroy]

      def index
        @banner_stores = BannerStore.all
                                    .page(params[:page])
                                    .per(10)
      end

      def new
        @banner_store = BannerStore.new
      end

      def create
        flash[:success] = I18n.t(:success_create_banner_store)
        redirect_to backoffice_admin_banner_stores_path
      end

      def edit; end

      def update
        if @banner_store.update(ensured_params)
          flash[:success] = I18n.t(:success_update_banner_store)
          redirect_to backoffice_admin_banner_stores_path
        else
          flash[:error] = I18n.t('defaults.saving_error')
          render :edit
        end
      end

      def destroy
        if @banner_store.update(active: false)
          flash[:success] = I18n.t(:success_inactivate_banner_store)
        else
          flash[:error] = I18n.t('defaults.destroying_error')
        end
        redirect_to backoffice_admin_banner_stores_path
      end

      private

      def ensure_creation
        # this step is necessary because of attachinary gem bug -
        # https://github.com/assembler/attachinary/issues/130
        # Remove this gem in favor of active storage
        new_params = ensured_params
        file = new_params.delete(:image)

        @banner_store = BannerStore.new(new_params)
        @banner_store.save
        return if @banner_store.persisted? && @banner_store.update(image: file)

        flash[:error] = @banner_store.errors.full_messages.join(', ')
        @banner_store.destroy
        render :new
      end

      def ensured_banner_store
        @banner_store = BannerStore.find(params[:id])
      end

      def ensured_params
        params.require(:banner_store).permit(:active, :image, :title)
      end
    end
  end
end
