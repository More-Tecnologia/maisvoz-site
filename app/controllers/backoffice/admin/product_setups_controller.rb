module Backoffice
  module Admin
    class ProductSetupsController < AdminController

      def index
        render(:index, locals: { product_setups: product_setups })
      end

      def show
        render(:show, locals: { product_setup: product_setup })
      end

      def update
        ActiveRecord::Base.transaction do
          product_setup.status_updated_at = Time.zone.now
          product_setup.status_message    = params[:status_message]
          product_setup.status            = params[:status]
          product_setup.save!
          
          credit_installer_bonus
          
          flash[:success] = "Instalação #{product_setup.id} atualizada com sucesso"
        end
        redirect_to backoffice_admin_product_setups_path
      end

      private

      def product_setups
        ProductSetupsQuery.new.call(params)
      end

      def product_setup
        @product_setup ||= ProductSetup.find(params[:id])
      end

      def credit_installer_bonus
        return if params[:status] != ProductSetup.statuses[:approved]
        Bonification::CreditInstallerBonus.new(product_setup).call
      end

    end
  end
end
