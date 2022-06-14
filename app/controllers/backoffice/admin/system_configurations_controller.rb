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
        redirect_to backoffice_admin_system_configurations_path if @config.persisted? && @config.update(logo: logo)

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
              .permit(:active, :banner_email, :base_host, :company_name,
                      :external_logo, :favico, :logo, :raffle_license_number,
                      :raffles_direct_commission_bonus, :reputation, :uptime,
                      :taxable_fee, :whitelabel, :withdrawal_fee,
                      :max_ticket_per_order, :payment_block_checkout_url,
                      :payment_block_authorization_key, :gateway_wallet_url,
                      :pagstar_api_url, :pagstar_login, :pagstar_access_key,
                      :pagstar_tenant_id, :pagstar_callback, :sender_email,
                      :financial_email, :company_domain_site, :contact_email,
                      :withdraw_minimum_value, :morenwm_customer_admin,
                      :morenwm_customer_username, :morenwm_username,
                      :current_currency, :current_digital_currency,
                      :cloudinary_url, :authorization_key)
      end
    end
  end
end
