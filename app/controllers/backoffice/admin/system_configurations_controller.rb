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
          # this step is necessary because of attachinary gem bug -
        # https://github.com/assembler/attachinary/issues/130
        # Remove this gem in favor of active storage
        new_params = ensured_params
        logo = new_params.delete(:logo)

        @config = SystemConfiguration.new(new_params)
        @config.save
        if @config.persisted? && @config.update(logo: logo)
          redirect_to backoffice_admin_system_configurations_path 
        end

        flash[:error] = @config.errors.full_messages.join(', ')
        @config.destroy
        render :new
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
              .permit(:active,
                      :banner_email,
                      :base_host,
                      :company_name,
                      :external_logo,
                      :favico,
                      :logo,
                      :raffle_license_number,
                      :raffles_direct_commission_bonus,
                      :reputation,
                      :taxable_fee,
                      :whitelabel,
                      :withdrawal_fee)
      end
    end
  end
end
