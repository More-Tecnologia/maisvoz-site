# frozen_string_literal: true

module Backoffice
  module Admin
    class SystemConfigurationsController < AdminController
      before_action :ensure_configuration, only: %i[edit update destroy]

      def index
        @configs = SystemConfiguration.page(params[:page])
                                      .per(10)
      end

      def new
        @config = SystemConfiguration.new
      end

      def create
        @config = SystemConfiguration.new(ensured_params)
        if @config.save
          flash[:success] = I18n.t(:success_create_configuration)
          redirect_to backoffice_admin_system_configurations_path
        else
          flash[:error] = I18n.t('defaults.saving_error')
          render :new
        end
      end

      def edit; end

      def update
        if @config.update(ensured_params)
          flash[:success] = I18n.t(:success_update_configuration)
          redirect_to backoffice_admin_system_configurations_path
        else
          flash[:error] = I18n.t('defaults.saving_error')
          render :new
        end
      end

      def destroy
        if @config.update(active: false)
          flash[:success] = I18n.t(:success_inactivate_configuration)
        else
          flash[:error] = I18n.t('defaults.saving_error')
        end
        redirect_to backoffice_admin_system_configurations_path
      end

      private

      def ensure_configuration
        @config = SystemConfiguration.find(params[:id])
      end

      def ensured_params
        params.require(:system_configuration)
              .permit(:company_name,
                      :taxable_fee,
                      :withdrawal_fee,
                      :active,
                      :reputation)
      end
    end
  end
end
